### Implementation.

<#
.Synopsis
    Temporarily add $Path to the $env:path and run $Action.
.Parameter Path
    The path to add to $env:path.
.Parameter Action
    The action to take.
.Example
    Add-Path C:/Programs/Git/bin git log
#>
function Add-Path ([string] $Path, [string] $Action)
{
    $hold = $env:Path
    $env:Path = "$Path;$env:Path"
    & $Action @args
    $env:Path = $hold
}

<#
.Synopsis
    Compare the hash value for a file with the specified hash.
.Parameter Path
    The path to the files.
.Parameter Algorithm
    The cryptographic hash function to use for computing the hash value of the contents of the specified file. Acceptable values are: SHA1, SHA256, SHA384, SHA512, and MD5. A dash (-) can be used to default to SHA256.
.Parameter Hash
    The hash string to compare the computed file hash to.
.Example
    Compare-FileHash a.txt - E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
    Compares the computed hash for a file with the specified hash.
.Outputs
    [Microsoft.PowerShell.Utility.FileHash]
    Compare-FileHash returns an object that represents the path to the specified file, the value of the computed hash, and the algorithm used to compute the hash.
#>
function Compare-FileHash ([string[]] $Path, [string] $Algorithm, [string] $Hash)
{
    $parameters = @{ Path = $Path }
    if ($Algorithm -and $Algorithm -ne "-") { $parameters.Algorithm =  $Algorithm }

    $fileHash = Get-FileHash @parameters

    if ($fileHash.Hash -eq $Hash) { Write-Host "`nThe file hash and the input hash match." -ForegroundColor Green }
    elseif (!$Hash) { Write-Host "`nInput hash is empty. Unable to compare hashes." -ForegroundColor Yellow }
    else { Write-Host "`nThe file hash and the input hash do not match. Ensure the file is secure." -ForegroundColor Red }

    $fileHash | Format-List
}

<#
.Synopsis
	List the commands in user modules.
.Outputs
    Formatted list of exported commands in user modules.
#>
function Get-UserModule
{
    $exported = @{ Name = "Exported"; Expression = { [string]::Join(', ', $PSItem.ExportedCommands.Keys) } }
    Get-Module ~/Documents/PowerShell/Modules/* -ListAvailable |
        Select-Object Name, $exported | Format-Table -Wrap
}

<#
.Synopsis
	Reimport user modules.
.Outputs
	Reimported modules.
#>
function Import-UserModule
{
    Get-Module ~/Documents/PowerShell/Modules/* -ListAvailable -Refresh |
        Import-Module -Force -PassThru
}

<#
.Synopsis
    Create symbolic links.
.Description
    Create symbolic links from the $Source path to the $Link path.
.Parameter Source
	Source to link to.
.Parameter Link
	Symbolic link path. Defaults to the last item of $Source.
.Example
	New-SymbolicLink C:/Programs/Git/bin/git.exe
	Creates a symbolic link for git.exe in the current directory.
#>
function New-SymbolicLink ([string] $Source, [string] $Link)
{
    # Return help if parameters are empty.
    if (!$Source) { return Get-Help $MyInvocation.MyCommand }

    # Return error if $Source does not exist.
    if (!(Test-Path $Source)) { return Write-Error -Exception ([System.IO.FileNotFoundException]::new("Cannot create symbolic link because the source path $Source does not exist.")) -Category ObjectNotFound -TargetObject $Source }

    # Use the last item of $Source as the default for $Link.
    if (!$Link) { $Link = Split-Path $Source -Leaf }

    # Return error if $Link already exists and is not a symbolic link.
    if ((Test-Path($Link)) -and ((Get-ItemProperty $Link).LinkType -ne 'SymbolicLink')) { return Write-Error -Exception ([System.IO.IOException]::new("Cannot create symbolic link because the link path $Link already exists and is not a symbolic link.")) -Category ResourceExists -TargetObject $Link }

    # Create symbolic link.
    New-Item -Path $Link -Value $Source -ItemType SymbolicLink @args
}

<#
.Synopsis
	Changes the extension of multiple files.
.Parameter Path
	The path to the files.
.Parameter Extension
	The new extension.
.Parameter Filter
	Filter applied to path.
.Example
	Rename-Extension *.txt .md
	Change the extension of all the .txt files in the current directory to .md.

    Rename-Extension * .jpg
    Change the extension of all files in the current directory to .jpg
#>
function Rename-Extension ([string[]] $Path, [string] $Extension, [string] $Filter)
{
    Get-ChildItem $Path -Filter $Filter |
        Rename-Item -NewName { [System.IO.Path]::ChangeExtension($PSItem.Name, $Extension) }
}

<#
.Synopsis
	Reset $env:Path.
.Description
	Reset $env:Path to user path + machine path. Remove directories added to $env:Path by other processes.
#>
function Reset-Path
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) + ";" +
    [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
}

<#
.Synopsis
    Temporarily switch the $env:path to $Path and run $Action.
.Parameter Path
    The path to switch $env:path to.
.Parameter Action
    The action to take.
.Example
    Switch-Path C:/Programs/Git/bin git log
#>
function Switch-Path ([string] $Path, [string] $Action)
{
    $hold, $env:Path = $env:Path, $Path
    & $Action @args
    $env:Path = $hold
}
