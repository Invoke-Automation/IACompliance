. $PSScriptRoot\_InitializeTests.ps1
Describe 'New-Rule' {
	It 'Should return an IAConplianceRule Object'{
		(New-Rule -Name 'Number is Even' -PreCheckScript {$Input -lt 2} -CheckScript {($Input % 2) -eq 0}).GetType().Name | Should -BeLike 'IAComplianceRule'
	}
}