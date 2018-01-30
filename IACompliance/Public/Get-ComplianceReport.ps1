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
		[switch] $NoOutput = $false
	)
	Begin {
	}
	Process {
		if(!$NoOutput){
			Write-Host ('Report: {0}' -f $Name) -ForegroundColor Yellow
		}
		$Results = @()
		foreach ($check in $Checks) {
			if(!$NoOutput){
				Write-Host ("  Check: {0}" -f $check.Name) -ForegroundColor Yellow
			}
			Invoke-Command -ScriptBlock $check.InputScript | ForEach-Object {
				if(!$NoOutput){
					Write-Host ("    Object: {0}" -f $_) -ForegroundColor Yellow
				}
				foreach ($rule in $check.Rules) {
					if($rule.ShouldBeChecked($_)){
						$RuleCheckResult = [IAComplianceRuleCheckResult]::New($check, $rule, $_, $rule.Check($_))
						$Results += $RuleCheckResult
						if ($RuleCheckResult.IsCompliant) {
							if(!$NoOutput){
								Write-Host ("      Rule: {0}" -f $rule.Name) -ForegroundColor Green
							}
						} else {
							if(!$NoOutput){
								Write-Host ("      Rule: {0}" -f $rule.Name) -ForegroundColor Red
							}
						}
					}
				}
			}
		}
		if($PassThru){
			New-Object -TypeName 'PSObject' -Property @{
				'ReportName' = $Name
				'Results'    = $Results
			}
		}
	}
	End {
	}
}
