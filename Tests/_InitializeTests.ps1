#if(!((Get-Module IACompliance).Version -gt [version]'0.1.0')){
if(!(Get-Module IACompliance)){
	Import-Module $PSScriptRoot\..\IACompliance -Force
}

$TestRule1Name = 'Number is Even'
$TestRule1PreCheckScript = {$Input -lt 2}
$TestRule1CheckScript = {($Input % 2) -eq 0}

$TestCheckName = 'Holy Compliance'
$TestCheckInputScript = {@(1,2,3,4,5,'q')}