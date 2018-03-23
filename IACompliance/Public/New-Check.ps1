function New-Check {
	[CmdletBinding()]
	Param (
		# Name of the rule
		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[ValidateNotNullOrEmpty()]
		[System.String] $Name,
		# ScriptBlock to generate input objects
		[Parameter(
			Mandatory = $true,
			Position = 2
		)]
		[Alias('This')]
		[ValidateNotNullOrEmpty()]
		[ScriptBlock] $InputScript,
		# Set of rules to check
		[Parameter(
			Mandatory = $true,
			Position = 3
		)]
		[Alias('Against')]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({
			$_ | Foreach-Object {
				$_.GetType().Name -like 'IAComplianceRule'
			}
		})]
		[System.Object[]] $Rules
	)
	Begin {
	}
	Process {
		[IAComplianceCheck]::New($Name,$InputScript,$Rules)
	}
	End {
	}
}
