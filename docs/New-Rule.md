---
external help file: IACompliance-help.xml
Module Name: IACompliance
online version:
schema: 2.0.0
---

# New-Rule

## SYNOPSIS
Make a new IAComplianceRule

## SYNTAX

### NoPreCheck (Default)
```
New-Rule [-Name] <String> [-CheckScript] <ScriptBlock> [<CommonParameters>]
```

### WithPreCheck
```
New-Rule [-Name] <String> [-PreCheckScript] <ScriptBlock> [-CheckScript] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
The New-Rule cmdlet creates an IAComplianceRule object.
An IAComplianceRule object is used to check whether or not an object complies with the defined Rule.
If a PreCheck is defined an object wil only be checked if the PreCheck returns $true.


**Aliasses**

For readability purposes several Aliases are defined for the New-Rule cmdlet and its Parameters.


**Framework**

IAComplianceRule objects (`New-Rule` | `Rule`) are designed to be combined in an IAComplianceCheck (`New-Check` | `Check`) which can then be used to generate an IAComplianceReport (`Get-IAComplianceReport`).

## EXAMPLES

### EXAMPLE 1
```powershell
$newRule = Rule 'Should start with capital letter' -For {
	$Input[0].GetType().Name -like 'String'
} -Check {
	$Input -cmatch '^[A-Z]'
}
```

Am IAComplianceRule object being created using the New-Rule cmdlet aliasses.
This Rule checks if the Object to be checked is of the type 'String'.
If the oject is of that type it checks if the String starts with a capital letter.
* $newRule.Check('Test') will return $true
* $newRule.Check('test') will return $false
* $newRule.Check(4) will return $null

### EXAMPLE 2
```powershell
$newRule = New-Rule 'Should be in obscure list' -CheckScript {
	$Input -in @(' ',4,(Get-Date -Day 1 -Month 1 -Year 1970))
}
```

This Rule checks if an object is in the list `@(' ',4,(Get-Date -Day 1 -Month 1 -Year 1970))`.
* $newRule.Check(4) will return $true
* $newRule.Check(Get-Date) will return $false

## PARAMETERS

### -Name
Name of the Rule.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreCheckScript
ScriptBlock to check if Rule applies to an object.

This parameter descirbes the ScriptBlock that will be run when the compliance of an object is checked. The object to be checked can be accessed through the $Input automatic variable.

If the ScriptBlock returns $true the object will be checked against the CheckScript otherwise the check will return $null.

```yaml
Type: System.Management.Automation.ScriptBlock
Parameter Sets: WithPreCheck
Aliases: For

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CheckScript
ScriptBlock to check compliance of an object.

This parameter describes the ScriptBlock that will be run when the the compliance of an object is checked and the PreCheck (if defined) returned $true. The object to be checked can be accessed through the $Input automatic variable.

If the ScriptBlock returns $true the object complies with this Rule, if not the object does not comply with this Rule.

```yaml
Type: System.Management.Automation.ScriptBlock
Parameter Sets: (All)
Aliases: Check

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

### IAComplianceRule
	The cmdlet returns an IAComplianceRule object.

## NOTES

## RELATED LINKS
