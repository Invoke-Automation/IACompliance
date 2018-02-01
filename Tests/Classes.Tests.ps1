. $PSScriptRoot\_InitializeTests.ps1

. $PSScriptRoot\..\IACompliance\Private\_Classes.ps1

Describe 'IAComplianceRule' {
	It 'Should have a constructor with Name,PreCheck,CheckScript' {
		{
			$rule = [IAComplianceRule]::New($TestRule1Name,$TestRule1PreCheckScript,$TestRule1CheckScript)
			$rule.Name | Should -Be $TestRule1Name
			$rule.PreCheckScript | Should -Be $TestRule1PreCheckScript
			$rule.CheckScript | Should -Be $TestRule1CheckScript
		} | Should -Not -Throw
	}
	It 'Should have a constructor with Name,CheckScript' {
		{
			$rule = [IAComplianceRule]::New($TestRule1Name,$TestRule1CheckScript)
			$rule.Name | Should -Be $TestRule1Name
			$rule.CheckScript | Should -Be $TestRule1CheckScript
		} | Should -Not -Throw
	}
}

Describe 'IAComplianceCheck' {
}

Describe 'IAComplianceRuleCheckResult' {
}

Describe 'IAComplianceReport' {
}