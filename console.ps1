# Check whether the following packages are installed.
# See `C:\ProgramData\chocolatey\bin` for all installed packages.
$check_installed = "choco.exe","git.exe","rg.exe","nvim.exe", "jq.exe", "zoxide.exe", "fzf.exe"
# carapace, PsFzf are installed with scoop

foreach ($package in $check_installed) {
  if (!(Get-Command -Name $package -ErrorAction SilentlyContinue)) {
    Write-Host "$($package) not available"
  }
}

# Aliases
Set-Alias -Name vim   -Value nvim
Set-Alias -Name ex    -Value explorer
Set-Alias -Name fe    -Value FindFile # See function `FindFile` below.

# Carapace options
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

# Show history. History mode has two options: predition and listview. It can be toggled with `F2`.
Set-PSReadLineOption -PredictionViewStyle ListView
# Scroll through history suggestions with `Ctrl+n` and `Ctrl+p` key combinations.
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextHistory 
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousHistory 

# Open PS fzf with <C-t>
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' 

# Init zoxide in PS, then set alias.
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Set-Alias -Name cd -Value z -Option AllScope

# Create a function to trigger fzf from the current directory to bind to `fe`: 'Find Everything'.
function FindFile {
  Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { nvim $_ }
}
