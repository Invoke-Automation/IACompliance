. $PSScriptRoot\_InitializeTests.ps1

Describe 'New-Rule' {
	It 'Should require a non-null Name' {
		{New-Rule -Name $null -PreCheckScript $TestRule1PreCheckScript -CheckScript $TestRule1CheckScript} | Should -Throw
	}
	It 'Should require a non-null Check' {
		{New-Rule -Name $TestRule1Name -PreCheckScript $TestRule1PreCheckScript -CheckScript $null} | Should -Throw
	}
	It 'Should not require a PreCheck' {
		{New-Rule -Name $TestRule1Name -CheckScript $TestRule1CheckScript} | Should -Not -Throw
	}
	It 'Should return an IAConplianceRule Object'{
		(New-Rule -Name $TestRule1Name -PreCheckScript $TestRule1PreCheckScript -CheckScript $TestRule1CheckScript).GetType().Name | Should -BeLike 'IAComplianceRule'
	}
	It 'Should not throw when using user friendly notation with PreCheck' {
		{
			New-Rule 'Number is Even' {
				$Input -lt 2
			} {
				($Input % 2) -eq 0
			}
		} | Should -Not -Throw
	}
	It 'Should not throw when using user friendly notation without PreCheck' {
		{
			New-Rule 'Number is Even' {
				($Input % 2) -eq 0
			}
		} | Should -Not -Throw
	}
}