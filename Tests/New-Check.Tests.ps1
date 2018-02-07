. $PSScriptRoot\_InitializeTests.ps1

Describe 'New-Check' {
	$TestRule1 = New-Rule $TestRule1Name $TestRule1PreCheckScript $TestRule1CheckScript

	It 'Should require a non-null Name parameter' {
		{New-Check -Name $null -InputScript $TestCheckInputScript -Rules $TestRule1} | Should -Throw
	}
	It 'Should require a non-null InputScript parameter' {
		{New-Check -Name $TestCheckName -InputScript $null -Rules $TestRule1}  | Should -Throw
	}
	It 'Should require a non-null Rules parameter' {
		{New-Check -Name $TestCheckName -InputScript $TestCheckInputScript -Rules $null}  | Should -Throw
	}
	It 'Should return an IAComplianceCheck Object'{
		{
			$check = New-Check -Name $TestCheckName -InputScript $TestCheckInputScript -Rules $TestRule1
			$check.Name | Should -Be $TestCheckName
			$check.InputScript | Should -Be $TestCheckInputScript
			$check.Rules | Should -Be $TestRule1
			$check.GetType().Name | Should -BeLike 'IAComplianceCheck'
		} | Should -Not -Throw
	}
	It 'Should not throw when using user friendly notation with words' {
		{
			$check = Check $TestCheckName -This $TestCheckInputScript -Against $TestRule1
			
			$check.Name | Should -Be $TestCheckName
			$check.InputScript | Should -Be $TestCheckInputScript
			$check.Rules | Should -Be $TestRule1
			$check.GetType().Name | Should -BeLike 'IAComplianceCheck'
		} | Should -Not -Throw
	}
	It 'Should not throw when using user friendly notation without words' {
		{
			$check = Check $TestCheckName $TestCheckInputScript $TestRule1
			
			$check.Name | Should -Be $TestCheckName
			$check.InputScript | Should -Be $TestCheckInputScript
			$check.Rules | Should -Be $TestRule1
			$check.GetType().Name | Should -BeLike 'IAComplianceCheck'
		} | Should -Not -Throw
	}
}