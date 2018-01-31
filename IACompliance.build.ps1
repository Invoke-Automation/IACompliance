# Ensure everything works in the most strict mode.
Set-StrictMode -Version Latest

if($env:APPVEYOR){
    $RepoRoot = $env:APPVEYOR_BUILD_FOLDER
} else {
    $RepoRoot = $PSScriptRoot
}
$ModuleName = 'IACompliance'
$ModulePath = Join-Path $RepoRoot $ModuleName
$PublicFunctionsPath = Join-Path $ModulePath 'Public'
$DocsPath = Join-Path $RepoRoot 'docs'
$DocsLocale = 'en-US'
$ModuleManifestPath = Join-Path $ModulePath "$ModuleName.psd1"
$LocalBuildPath = Join-Path $RepoRoot 'build'

task ShowDebug {
    Write-Build Gray
    Write-Build Gray ('Project name:               {0}' -f $env:APPVEYOR_PROJECT_NAME)
    Write-Build Gray ('Project root:               {0}' -f $env:APPVEYOR_BUILD_FOLDER)
    Write-Build Gray ('Repo name:                  {0}' -f $env:APPVEYOR_REPO_NAME)
    Write-Build Gray ('Branch:                     {0}' -f $env:APPVEYOR_REPO_BRANCH)
    Write-Build Gray ('Commit:                     {0}' -f $env:APPVEYOR_REPO_COMMIT)
    Write-Build Gray ('  - Author:                 {0}' -f $env:APPVEYOR_REPO_COMMIT_AUTHOR)
    Write-Build Gray ('  - Time:                   {0}' -f $env:APPVEYOR_REPO_COMMIT_TIMESTAMP)
    Write-Build Gray ('  - Message:                {0}' -f $env:APPVEYOR_REPO_COMMIT_MESSAGE)
    Write-Build Gray ('  - Extended message:       {0}' -f $env:APPVEYOR_REPO_COMMIT_MESSAGE_EXTENDED)
    Write-Build Gray ('Pull request number:        {0}' -f $env:APPVEYOR_PULL_REQUEST_NUMBER)
    Write-Build Gray ('Pull request title:         {0}' -f $env:APPVEYOR_PULL_REQUEST_TITLE)
    Write-Build Gray ('AppVeyor build ID:          {0}' -f $env:APPVEYOR_BUILD_ID)
    Write-Build Gray ('AppVeyor build number:      {0}' -f $env:APPVEYOR_BUILD_NUMBER)
    Write-Build Gray ('AppVeyor build version:     {0}' -f $env:APPVEYOR_BUILD_VERSION)
    Write-Build Gray ('AppVeyor job ID:            {0}' -f $env:APPVEYOR_JOB_ID)
    Write-Build Gray ('Build triggered from tag?   {0}' -f $env:APPVEYOR_REPO_TAG)
    Write-Build Gray ('  - Tag name:               {0}' -f $env:APPVEYOR_REPO_TAG_NAME)
    Write-Build Gray ('PowerShell version:         {0}' -f $PSVersionTable.PSVersion.ToString())
    Write-Build Gray
}

task GetVersion {
    $manifest = Test-ModuleManifest -Path $ModuleManifestPath
    [System.Version]$version = $manifest.Version
    Write-Host "Old Version: $version"
    if($env:APPVEYOR){
        $env:version = New-Object -TypeName System.Version -ArgumentList ($version.Major, $version.Minor, ($version.Build +1 ))
        Write-Host "New Version: $env:version"
    }  else {
        $env:version = New-Object -TypeName System.Version -ArgumentList ($version.Major, $version.Minor, $version.Build, ($version.Revision + 1))
        Write-Host "New Version: $env:version"
    }
}

task PesterTests {
    try {
        $testResultsFile = "$RepoRoot\TestResult.xml"
        $result = Invoke-Pester -OutputFormat NUnitXml -OutputFile $testResultsFile -PassThru
        if ($env:APPVEYOR) {
            (New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path $testResultsFile))
        }
        Remove-Item $testResultsFile -Force
        assert ($result.FailedCount -eq 0) "$($result.FailedCount) Pester test(s) failed."
    }
    catch {
        throw
    }
}

task Docs {
    # determin parameters
	if(-not ((Test-Path $DocsPath) -and (Test-Path $ModulePath))){
		throw "Repository structure does not look OK"
	} else {
		if (Get-Module -ListAvailable -Name platyPS) {
			# Import modules
			Import-Module platyPS
			Import-Module $modulePath -Force

			# Generate markdown and external help (Will overwrite existing)
			New-MarkdownHelp -Module $ModuleName -OutputFolder $docsPath -Locale $DocsLocale -Force
			New-ExternalHelp -Path $docsPath -OutputPath (Join-Path -Path $modulePath -ChildPath $DocsLocale) -Force
		} else {
			throw "You require the platyPS module to generate new documentation"
		}
	}
}

task AppVeyorBuild -If ($env:APPVEYOR) GetVersion, Docs, {
    # Make sure we're using the Master branch and that it's not a pull request
    # Environmental Variables Guide: https://www.appveyor.com/docs/environment-variables/
    if ($env:APPVEYOR_REPO_BRANCH -ne 'master') {
        Write-Warning -Message "Skipping version increment and publish for branch $env:APPVEYOR_REPO_BRANCH"
    } elseif ($env:APPVEYOR_PULL_REQUEST_NUMBER -gt 0) {
        Write-Warning -Message "Skipping version increment and publish for pull request #$env:APPVEYOR_PULL_REQUEST_NUMBER"
    } else {
        # We're going to add 1 to the revision value since a new commit has been merged to Master
        # This means that the major / minor / build values will be consistent across GitHub and the Gallery
        Try {
            # Update the manifest with the new version value and fix the weird string replace bug
            $functionList = ((Get-ChildItem -Path $PublicFunctionsPath -Recurse -Filter "*.ps1").BaseName)
            Update-ModuleManifest -Path $ModuleManifestPath -ModuleVersion $env:version -FunctionsToExport $functionList
            (Get-Content -Path $ModuleManifestPath) -replace "PSGet_$ModuleName", "$ModuleName" | Set-Content -Path $ModuleManifestPath
            (Get-Content -Path $ModuleManifestPath) -replace 'NewManifest', "$ModuleName" | Set-Content -Path $ModuleManifestPath
            (Get-Content -Path $ModuleManifestPath) -replace 'FunctionsToExport = ', 'FunctionsToExport = @(' | Set-Content -Path $ModuleManifestPath -Force
            (Get-Content -Path $ModuleManifestPath) -replace "$($functionList[-1])'", "$($functionList[-1])')" | Set-Content -Path $ModuleManifestPath -Force
        } catch {
            throw $_
        }
    }
}

task AppVeyorPublish -If ($env:APPVEYOR) {
    # Publish Module to PSGallery
    Try {
        Publish-Module -Path $ModulePath -NuGetApiKey $env:NuGetApiKey -ErrorAction 'Stop'
        Write-Host "$ModuleName PowerShell Module version $env:version published to the PowerShell Gallery." -ForegroundColor Cyan
    } Catch {
        Write-Warning "Publishing update $env:version to the PowerShell Gallery failed."
        throw $_
    }
}

task LocalBuild -If (!$env:APPVEYOR) PesterTests, Docs, {
    if(Test-Path $ModuleManifestPath){
        $manifest = Test-ModuleManifest -Path $ModuleManifestPath
        [System.Version]$version = $manifest.Version
        Write-Output "Old Version: $version"
        [String]$newVersion = New-Object -TypeName System.Version -ArgumentList ($version.Major, $version.Minor, $version.Build, ($version.Revision + 1))
        Write-Output "New Version: $newVersion"

        # Update the manifest with the new version value and fix the weird string replace bug
        $functionList = ((Get-ChildItem -Path $PublicFunctionsPath -Recurse -Filter "*.ps1").BaseName)
        Update-ModuleManifest -Path $ModuleManifestPath -ModuleVersion $newVersion -FunctionsToExport $functionList
        (Get-Content -Path $ModuleManifestPath) -replace "PSGet_$ModuleName", "$ModuleName" | Set-Content -Path $ModuleManifestPath
        (Get-Content -Path $ModuleManifestPath) -replace 'NewManifest', "$ModuleName" | Set-Content -Path $ModuleManifestPath
        (Get-Content -Path $ModuleManifestPath) -replace 'FunctionsToExport = ', 'FunctionsToExport = @(' | Set-Content -Path $ModuleManifestPath -Force
        (Get-Content -Path $ModuleManifestPath) -replace "$($functionList[-1])'", "$($functionList[-1])')" | Set-Content -Path $ModuleManifestPath -Force

        $BuildFolder = New-Item -Path $LocalBuildPath -Name ('{0}\{1}' -f $ModuleName,(Test-ModuleManifest -Path $ModuleManifestPath).Version) -ItemType Directory
        Copy-Item -Path (Join-Path $RepoRoot "$ModuleName\*") -Destination $BuildFolder -Recurse
    } else {
        throw 'Build requires Module Manifest'
    }
}

task LocalPublish -If (!$env:APPVEYOR) PesterTests, {
    Publish-Module -Path $ModulePath -NuGetApiKey (Get-Content '.\PSGallery.secret')
}

task . PesterTests, LocalBuild
