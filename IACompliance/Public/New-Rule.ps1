function New-Rule {
	[CmdletBinding(
		DefaultParameterSetName = 'NoPreCheck'
	)]
	Param (
		# Name of the rule
		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[ValidateNotNullOrEmpty()]
		[System.String] $Name,
		# ScriptBlock to check if rule applies to object
		[Parameter(
			ParameterSetName = 'WithPreCheck',
			Mandatory = $true,
			Position = 2
		)]
		[Alias('For')]
		[ValidateNotNullOrEmpty()]
		[ScriptBlock] $PreCheckScript,
		# ScriptBlock to check compliance of object
		[Parameter(
			ParameterSetName = 'WithPreCheck',
			Mandatory = $true,
			Position = 3
		)]
		[Parameter(
			ParameterSetName = 'NoPreCheck',
			Mandatory = $true,
			Position = 2
		)]
		[Alias('Check')]
		[ValidateNotNullOrEmpty()]
		[ScriptBlock] $CheckScript
	)
	Begin {
	}
	Process {
		switch($PSCmdlet.ParameterSetName){
			'WithPreCheck'{
				Write-Verbose 'Creating Rule with PreCheck'
				[IAComplianceRule]::New($Name,$PreCheckScript,$CheckScript)
			}
			'NoPreCheck'{
				Write-Verbose 'Creating Rule without PreCheck'
				[IAComplianceRule]::New($Name,$CheckScript)
			}
			default {
				throw 'Something went wrong with the parameterset names.'
			}
		}
	}
	End {
	}
}
