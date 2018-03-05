---
URL: https://invoke-automation.github.io/Invoke-Documentation/projects/IACompliance/README
index: 0
---

[![Build status](https://ci.appveyor.com/api/projects/status/dp9nhmtfcrvey2ht/branch/master?svg=true)](https://ci.appveyor.com/project/TomasDeceuninck/iacompliance/branch/master)

# IACompliance

Invoke-Automation Compliance module is designed as a framework for descibing rules in PowerShell and checking the compliance of these rules on specified objects.

## Getting started

Install IACompliance from the [PowerShell Gallery](https://www.powershellgallery.com/) using `Install-Module`.

```powershell
Install-Module -Name IACompliance
```

## Getting a report

To generate a report you first need to describe Rule (IAComplianceRule) objects.
```powershell
$rule1 = Rule 'Should start with capital letter' -For {
		$Input[0].GetType().Name -like 'String'
	} -Check {
		$Input -cmatch '^[A-Z]'
	}
```

Once you have one or more rules you can describe a check (IAComplianceCheck) object, wich defines what objects should comply with these rules.
```powershell
$check1 = Check 'StringCheck' -This {
		@('Test1','test2','Test 3','Test-4')
	} -Against {
		@(
			$rule1,
			Rule 'Should not contain any spaces' -For {
				$Input[0].GetType().Name -like 'String'
			} -Check {
				$Input.IndexOf(' ') -lt 0
			}
		)
	}
```

When you have described one or more checks you can combine these in a report using the *Get-ComplianceReport* cmdlet.
By default this wil generate your report to the console but you can ask it to give back an IAComplianceReport object by using the *-PassThru* parameter.
```powershell
Get-ComplianceReport -Name 'Alphanumeric Compliance Report' -Checks @(
	$check1,
	Check 'Number Check' -This {
		@(2,3,5,12,2.4)
	} -Against {
		@(
			Rule 'Should be an even number' -For {
				$Input[0].GetType().Name -like 'Int32'
			} -Check {
				$Input % 2 -eq 0
			}
		)
	}
) -PassTru
```

## Contributing to IACompliance

### Found a bug?

Submit a bug report via [Issues](https://github.com/Invoke-Automation/IACompliance/issues)

### You want to contribute?

Awesome! Take a look at [CONTRIBUTING.md](CONTRIBUTING.md)

## Legal and Licensing

IACompliance is licensed under the [MIT license](LICENSE.txt).

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.