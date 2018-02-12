---
external help file: IACompliance-help.xml
Module Name: IACompliance
online version:
schema: 2.0.0
---

# New-Rule

## SYNOPSIS
{{Fill in the Synopsis}}

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
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -CheckScript
{{Fill CheckScript Description}}

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases: Check

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreCheckScript
{{Fill PreCheckScript Description}}

```yaml
Type: ScriptBlock
Parameter Sets: WithPreCheck
Aliases: For

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
