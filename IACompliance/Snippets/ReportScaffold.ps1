# Module imports
# all required modules and their minimum version that are needed to perform the checks.

Get-ComplianceReport 'AD Compliance Report' -Checks @(
	New-Check 'AD Naming Conventions' -Input {
		#Input Objects
		Get-ADGroup -Filter *
	} -Rules @(
		# Rules
		New-Rule 'Global Security Groups Should start with "G"' {
			$Input.GroupCategory -like 'Security' -and $Input.GroupScope -like 'Global'
		} {
			$requiredLetter = 'G'
			$Input.Name.StartsWith($requiredLetter) -and $Input.SamAccountName.StartsWith($requiredLetter)
		}

		New-Rule 'Universal Security Groups Should start with "U"' {
			$Input.GroupCategory -like 'Security' -and $Input.GroupScope -like 'Universal'
		} {
			$requiredLetter = 'U'
			$Input.Name.StartsWith($requiredLetter) -and $Input.SamAccountName.StartsWith($requiredLetter)
		}

		New-Rule 'DomainLocal Security Groups Should start with "L"' {
			$Input.GroupCategory -like 'Security' -and $Input.GroupScope -like 'DomainLocal'
		} {
			$requiredLetter = 'L'
			$Input.Name.StartsWith($requiredLetter) -and $Input.SamAccountName.StartsWith($requiredLetter)
		}
	)
)