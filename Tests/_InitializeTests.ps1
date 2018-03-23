$ModuleName = 'IACompliance'
$TestsFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $TestsFolder
$ModuleRoot = Join-Path $ProjectRoot $ModuleName

#if(!((Get-Module IACompliance).Version -gt [version]'0.1.0')){
if(!(Get-Module IACompliance)){
	Import-Module $ModuleRoot -Force
}

#$ErrorActionPreference = 'SilentlyContinue'

$TestRule1Name = 'Number is Even'
$TestRule1PreCheckScript = {$Input -lt 2}
$TestRule1CheckScript = {($Input % 2) -eq 0}

$TestCheckName = 'Holy Compliance'
$TestCheckInputScript = {@(1,2,3,4,5,'q')}

$TestReportCheckInput = @('test-01','Test02','Test-03',4,$null)
$TestReportCheck1 = New-Check 'Naming convention' {
	$TestReportCheckInput
} -Rules @(
	Rule 'Should start with capital letter' -For {
		$Input[0].GetType().Name -like 'String'
	} -Check {
		$Input -cmatch '^[A-Z]'
	}
	Rule 'Should end with dash-number-number' -For {
		$Input[0].GetType().Name -like 'String'
	} -Check {
		$Input -cmatch '\-[0-9]{2}$'
	}
)
$TestReportCheck2 = New-Check 'ObjectTypes' {
	$TestReportCheckInput
} -Rules @(
	Rule 'All names should be strings' -Check {
		$Input[0].GetType().Name -like 'String'
	}
)
