. $PSScriptRoot\_InitializeTests.ps1

. $PSScriptRoot\..\IACompliance\Private\_Classes.ps1

Describe 'IAComplianceRule' {
	It 'Should have a constructor with Name,PreCheck,CheckScript' {
		{[IAComplianceRule]::New($TestRule1Name,$TestRule1PreCheckScript,$TestRule1CheckScript)} | Should -Not -Throw
	}
	It 'Should have a constructor with Name,CheckScript' {
		{[IAComplianceRule]::New($TestRule1Name,$TestRule1CheckScript)} | Should -Not -Throw
	}
}

Describe 'IAComplianceCheck' {
}

Describe 'IAComplianceRuleCheckResult' {
}

Describe 'IAComplianceReport' {
}