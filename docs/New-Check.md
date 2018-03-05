---
external help file: IACompliance-help.xml
Module Name: IACompliance
online version:
schema: 2.0.0
---

# New-Check

## SYNOPSIS
Make a new IAComplianceCheck

## SYNTAX

```
New-Check [-Name] <String> [-InputScript] <ScriptBlock> [-Rules] <Object[]> [<CommonParameters>]
```

## DESCRIPTION
The New-Check cmdlet creates an IAComplianceCheck object.
An IAComplianceCheck object is used to check several objects against a list of Rules.
These Rules are defined as a list of IAComplianceRule objects. The Objects to be checked can be desribed using a script that gets those objects.

**Aliasses**

For readability purposes several Aliases are defined for the New-Check cmdlet and its Parameters.

**Framework**

IAComplianceCheck objects are used to combine objects (`InputScript`) with the IAComplianceRule objects (`New-Rule` | `Rule`) they should comply with. These Checks can then be used to generate an IAComplianceReport (`Get-IAComplianceReport`).

## EXAMPLES

### Example 1
```powershell
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
}
```

An IAComplianceCheck object being created using the New-Check cmdlet aliasses.
This Check describes that all objects generated in the InputScript (*-This*) should comply with the two Rules described in the Rules list (*-Against*).

## PARAMETERS

### -InputScript
ScriptBlock to describe the objects to check.

This parameter describes the ScriptBlock that will be run to generate the objects that should comply with the Rules that are listed in the *Rules* parameter.

```yaml
Type: System.Management.Automation.ScriptBlock
Parameter Sets: (All)
Aliases: This

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the Check.

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

### -Rules
List of IAComplianceRule objects.

This parameter describes the Rules with which the generated input objects should comply.

```yaml
Type: System.Object[]
Parameter Sets: (All)
Aliases: Against

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### IAComplianceCheck
	The cmdlet returns an IAComplianceCheck object.

## NOTES

## RELATED LINKS
