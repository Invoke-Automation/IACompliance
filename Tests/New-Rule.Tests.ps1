. $PSScriptRoot\_InitializeTests.ps1

Describe 'New-Rule' -Tag 'Rule' {
	It 'Should require a non-null Name parameter' {
		{New-Rule -Name $null -PreCheckScript $TestRule1PreCheckScript -CheckScript $TestRule1CheckScript} | Should -Throw
	}
	It 'Should require a non-null Check parameter' {
		{New-Rule -Name $TestRule1Name -PreCheckScript $TestRule1PreCheckScript -CheckScript $null} | Should -Throw
	}
	It 'Should not require a PreCheck parameter' {
		{New-Rule -Name $TestRule1Name -CheckScript $TestRule1CheckScript} | Should -Not -Throw
	}
	It 'Should return an IAConplianceRule Object'{
		(New-Rule -Name $TestRule1Name -PreCheckScript $TestRule1PreCheckScript -CheckScript $TestRule1CheckScript).GetType().Name | Should -BeLike 'IAComplianceRule'
	}
	It 'Should not throw when using user friendly notation with PreCheck' {
		{
			$rule = Rule $TestRule1Name -For $TestRule1PreCheckScript -Check $TestRule1CheckScript
			
			$rule.Name | Should -Be $TestRule1Name
			$rule.PreCheckScript | Should -Be $TestRule1PreCheckScript
			$rule.CheckScript | Should -Be $TestRule1CheckScript
		} | Should -Not -Throw
	}
	It 'Should not throw when using user friendly notation without PreCheck' {
		{
			$rule = Rule $TestRule1Name -Check $TestRule1CheckScript
			
			$rule.Name | Should -Be $TestRule1Name
			$rule.PreCheckScript | Should -Be $null
			$rule.CheckScript | Should -Be $TestRule1CheckScript
		} | Should -Not -Throw
	}
}