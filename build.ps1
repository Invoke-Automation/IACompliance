$ModuleName = 'IACompliance'
$BuildRootName = 'build'
$BuildRootPath = Join-Path $PSScriptRoot $BuildRootName
$BuildNameTemplate = '{0}\{1}'
$ModuleManifestPath = "$PSScriptRoot\$ModuleName\$ModuleName.psd1"

if(Test-Path $ModuleManifestPath){
    $ModuleInfo = Test-ModuleManifest -Path $ModuleManifestPath
    try {
        Update-ModuleManifest `
            -Path $ModuleManifestPath `
            -FunctionsToExport "*" `
            -AliasesToExport "*" `
            -VariablesToExport "*" `
            -CmdletsToExport "*" `
            -ModuleVersion ([version]('{0}.{1}.{2}.{3}' -f $ModuleInfo.Version.Major,$ModuleInfo.Version.Minor,($ModuleInfo.Version.Build + 1),$ModuleInfo.Version.Revision))
    } catch {
        throw 'Could not update Module Manifest.'
    }

    $BuildFolder = New-Item -Path $BuildRootPath -Name ($BuildNameTemplate -f $ModuleName,(Test-ModuleManifest -Path $ModuleManifestPath).Version) -ItemType Directory
    Copy-Item -Path (Join-Path $PSScriptRoot "$ModuleName\*") -Destination $BuildFolder -Recurse
} else {
    throw 'Build requires Module Manifest'
}