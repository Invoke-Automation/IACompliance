
Import-Module .\IACompliance -Verbose -Force
$Rules = @(
	# Rules
	New-Rule 'Global Security Groups Should start with "G"' {
		$_.GroupCategory -like 'Security' -and $_.GroupScope -like 'Global'
	} {
		$requiredLetter = 'G'
		$_.Name.StartsWith($requiredLetter) -and $_.SamAccountName.StartsWith($requiredLetter)
	} -Verbose

	New-Rule 'Universal Security Groups Should start with "U"' {
		$_.GroupCategory -like 'Security' -and $_.GroupScope -like 'Universal'
	} {
		$requiredLetter = 'U'
		$_.Name.StartsWith($requiredLetter) -and $_.SamAccountName.StartsWith($requiredLetter)
	} -Verbose

	New-Rule 'DomainLocal Security Groups Should start with "L"' {
		$_.GroupCategory -like 'Security' -and $_.GroupScope -like 'DomainLocal'
	} {
		$requiredLetter = 'L'
		$_.Name.StartsWith($requiredLetter) -and $_.SamAccountName.StartsWith($requiredLetter)
	} -Verbose
)

. .\IACompliance\Private\_Classes.ps1
[IAComplianceCheck]::New('test', {$test = '1'}, ($Rules | Select -first 1))
[IAComplianceCheck]::New('test', {$test = '1'}, $Rules)
[IAComplianceCheck]::New('AD Naming Conventions', {Get-ADGroup -Filter * -SearchBase "OU=UniversalRoles,OU=_Rolegroups,OU=_Groups,DC=be,DC=lidl,DC=net" -SearchScope Subtree}, $Rules)
$sb = {Get-ADGroup -Filter * -SearchBase "OU=UniversalRoles,OU=_Rolegroups,OU=_Groups,DC=be,DC=lidl,DC=net" -SearchScope Subtree}
New-Check 'AD Naming Conventions' -Input $sb -Rules $Rules -Verbose

New-Check 'AD Naming Conventions' -Input {
	Get-ADGroup -Filter * -SearchBase "OU=UniversalRoles,OU=_Rolegroups,OU=_Groups,DC=be,DC=lidl,DC=net" -SearchScope Subtree
} -Rules (New-Rule 'Global Security Groups Should start with "G"' {
		$_.GroupCategory -like 'Security' -and $_.GroupScope -like 'Global'
	} {
		$requiredLetter = 'G'
		$_.Name.StartsWith($requiredLetter) -and $_.SamAccountName.StartsWith($requiredLetter)
	}) -Verbose

Import-Module .\IACompliance -Verbose -Force

$testRule = New-Rule 'Global Security Groups Should start with "G"' {
	$Input.GroupCategory -eq 'Security' -and $Input.GroupScope -eq 'Global'
} {
	$requiredLetter = 'G'
	$Input.Name.StartsWith($requiredLetter) -and $Input.SamAccountName.StartsWith($requiredLetter)
} -Verbose