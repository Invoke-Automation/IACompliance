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
		(New-Check -Name $TestCheckName -InputScript $TestCheckInputScript -Rules $TestRule1).GetType().Name | Should -BeLike 'IAComplianceCheck'
	}
}