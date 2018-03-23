---
external help file: IACompliance-help.xml
Module Name: IACompliance
online version:
schema: 2.0.0
---

# Get-ComplianceReport

## SYNOPSIS
Generate a new compliance report.

## SYNTAX

```
Get-ComplianceReport [-Name] <String> [-Checks] <IAComplianceCheck[]> [-PassThru] [-Silent]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-ComplianceReport cmdlet generates a new compliance report for all defined Checks.

Foreach IAComplianceCheck provided for the *Checks* parameter the input objects will be generated and will be checked for compliance with every rule described in the Check. 

By default the compliance report is printed to the console.
When the *-PassThru* parameter is defined it will return an IAComplianceReport Object.
When the *-Silent* parameter is defined no output will be printed to the console.

**Framework**

An IAComplianceReport objects is the result of a compliance report (`Get-IAComplianceReport`) where one or multiple IAComplianceCheck objects (`New-Check` | `Check`) where processed.

## EXAMPLES

### Example 1
```powershell
Get-ComplianceReport -Name 'Alphanumeric Compliance Report' -Checks @(
	Check 'StringCheck' -This {
		@('Test1','test2','Test 3','Test-4')
	} -Against {
		@(
			Rule 'Should start with capital letter' -For {
				$Input[0].GetType().Name -like 'String'
			} -Check {
				$Input -cmatch '^[A-Z]'
			},
			Rule 'Should not contain any spaces' -For {
				$Input[0].GetType().Name -like 'String'
			} -Check {
				$Input.IndexOf(' ') -lt 0
			}
		)
	},
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

An IAComplianceReport object being created using the Get-ComplianceReport cmdlet.
This report will also write all compliance checks to the console.

## PARAMETERS

### -Checks
List of IAComplianceCheck objects.

This parameter descirbes the Checks which have to be processed to generate the report.

```yaml
Type: IAComplianceCheck[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the Report.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Switch to passthru the IAComplianceReport object.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Silent
Switch to suppress the output to the console.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### IAComplianceReport
	If the *-PassThru* parameter is given the cmdlet returns an IAComplianceReport object.

## NOTES

## RELATED LINKS
