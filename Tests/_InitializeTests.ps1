
#if(!((Get-Module IACompliance).Version -gt [version]'0.1.0')){
if(!(Get-Module IACompliance)){
	Import-Module $PSScriptRoot\..\IACompliance -Force
}