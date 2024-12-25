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
Set-Alias -Name vim -Value nvim
Set-Alias -Name ex -Value explorer
Set-Alias -Name fe -Value FindFile # See function `FindFile` below.
Set-Alias -Name g -Value git -Option AllScope
function Get-GitStatus {
  & git status $args 
}
New-Alias -Name gs -Value Get-GitStatus -Option AllScope
function Set-GitAdd {
  & git add . 
}
New-Alias -Name ga -Value Set-GitAdd -Option AllScope
function Set-GitCommit {
  & git commit -m $args 
}
New-Alias -Name gc -Value Set-GitCommit -Option AllScope -Force # Force to override existing `gc` -> Get-Content
function Set-GitQuickCommit {
  & git commit -am $args 
}
New-Alias -Name gq -Value Set-GitQuickCommit -Option AllScope
function Set-GitPull {
  & git pull 
}
New-Alias -Name gl -Value Set-GitPull -Force -Option AllScope
function Set-GitPush {
  & git push 
}
New-Alias -Name gp -Value Set-GitPush -Force -Option AllScope
function Get-GitCheckout {
  & git checkout $args 
}
New-Alias -Name gco -Value Get-GitCheckout -Force -Option AllScope
function Get-GitTree {
  & git log --all --graph --decorate --oneline 
}
New-Alias -Name gt -Value Get-GitTree -Force -Option AllScope
function Get-GitBranch {
  & git branch $args 
}
New-Alias -Name gb -Value Get-GitBranch -Force -Option AllScope

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
# Open PS fzf with <C-t>
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' 

# Init zoxide in PS, then set alias.
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Set-Alias -Name cd -Value z -Option AllScope

# Create a function to trigger fzf from the current directory to bind to `fe`: 'Find Everything'.
function FindFile {
  Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { nvim $_ }
}
