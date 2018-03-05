# Creates scafolding for checks
function Get-ComplianceReport {
	[CmdletBinding()]
	Param (
		# Name of the report
		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[System.String] $Name,
		# Set of checks to evaluate
		[Parameter(
			Mandatory = $true,
			Position = 2
		)]
		[IAComplianceCheck[]] $Checks,
		# Defines if you want to get the IAComplianceReport object
		[Parameter(
			Mandatory = $false
		)]
		[switch] $PassThru = $false,
		# Defines if you want to get the IAComplianceReport object
		[Parameter(
			Mandatory = $false
		)]
		[switch] $Silent = $false
	)
	Begin {
	}
	Process {
		if(!$Silent){
			Write-Host $Name -ForegroundColor Yellow
		}
		$Results = @()
		foreach ($check in $Checks) {
			if(!$Silent){
				Write-Host ("  " + $check.Name) -ForegroundColor Yellow
			}
			Invoke-Command -ScriptBlock $check.InputScript | Where-Object {$_ -ne $null} | ForEach-Object {
				if(!$Silent){
					Write-Host ("    " + $_.ToString()) -ForegroundColor Green
				}
				foreach ($rule in $check.Rules) {
					if($rule.ShouldBeChecked($_)){
						$RuleCheckResult = [IAComplianceRuleCheckResult]::New($check, $rule, $_, $rule.Check($_))
						$Results += $RuleCheckResult
						if ($RuleCheckResult.IsCompliant) {
							if(!$Silent){
								Write-Host ("      " + $rule.Name) -ForegroundColor DarkGreen
							}
						} else {
							if(!$Silent){
								Write-Host ("      " + $rule.Name) -ForegroundColor DarkRed
							}
						}
					}
				}
			}
		}
		if($PassThru){
			[IAComplianceReport]::New($Name,$Results)
		}
	}
	End {
	}
}
