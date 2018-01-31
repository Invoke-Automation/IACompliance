# Ensure everything works in the most strict mode.
Set-StrictMode -Version Latest

$RepoRoot = $PSScriptRoot
$ModuleName = 'IACompliance'
$ModulePath = Join-Path $RepoRoot $ModuleName
$PublicFunctionsPath = Join-Path $ModulePath 'Public'
$DocsPath = Join-Path $RepoRoot 'docs'
$DocsLocale = 'en-US'
$ModuleManifestPath = Join-Path $ModulePath "$ModuleName.psd1"
$LocalBuildPath = Join-Path $RepoRoot 'build'

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

task AppVeyorBuild -If ($env:APPVEYOR) Docs, {
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
            Update-ModuleManifest -Path $ModuleManifestPath -ModuleVersion $env:APPVEYOR_BUILD_VERSION -FunctionsToExport $functionList
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
        Write-Host "$ModuleName PowerShell Module version $env:APPVEYOR_BUILD_VERSION published to the PowerShell Gallery." -ForegroundColor Cyan
    } Catch {
        Write-Warning "Publishing update $env:APPVEYOR_BUILD_VERSION to the PowerShell Gallery failed."
        throw $_
    }

    # Publish the new version back to Master on GitHub
    Try {
        # Set up a path to the git.exe cmd, import posh-git to give us control over git, and then push changes to GitHub
        # Note that "update version" is included in the appveyor.yml file's "skip a build" regex to avoid a loop
        $env:Path += ";$env:ProgramFiles\Git\cmd"
        Import-Module posh-git -ErrorAction Stop
        git config --global credential.helper store
        Add-Content "$env:USERPROFILE\.git-credentials" "https://$($env:GitHubKey):x-oauth-basic@github.com`n"
        git checkout master
        git add --all
        git status
        git commit -s -m "Update version to $env:APPVEYOR_BUILD_VERSION"
        git push origin master
        Write-Host "$ModuleName PowerShell Module version $env:APPVEYOR_BUILD_VERSION published to GitHub." -ForegroundColor Cyan
    } Catch {
        # Sad panda; it broke
        Write-Warning "Publishing update $env:APPVEYOR_BUILD_VERSION to GitHub failed."
        throw $_
    }
}

task LocalBuild -If (!$env:APPVEYOR) Docs, {
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

task . PesterTests, LocalBuild
