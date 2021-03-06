# Load Module settings file
try {
	$script:SETTINGS = ([xml](Get-Content "$PSScriptRoot\Settings.xml")).Settings
} catch {
	throw 'Could not load settings.xml file.'
}

# Get public and private function defenition files.
# Sort to make sure files that start with '_' get loaded first
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private -Recurse -Filter "*.ps1") | Sort-Object Name
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public -Recurse -Filter "*.ps1") | Sort-Object Name

# Dots source the private files
foreach ($import in $Private) {
	try {
		. $import.fullName
		Write-Verbose -Message ("Imported private function {0}" -f $import.fullName)
	} catch {
		Write-Error -Message ("Failed to import private function {0}: {1}" -f $import.fullName, $_)
	}
}
# Dots source the public files
foreach ($import in $Public) {
	try {
		. $import.fullName
		Write-Verbose -Message ("Imported public function {0}" -f $import.fullName)
	} catch {
		Write-Error -Message ("Failed to import public function {0}: {1}" -f $import.fullName, $_)
	}
}

Set-Alias -Name 'Check' -Value New-Check
Set-Alias -Name 'Rule' -Value New-Rule

Export-ModuleMember -Function $Public.BaseName -Alias *