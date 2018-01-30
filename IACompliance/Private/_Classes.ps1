class IAComplianceRule {
	# Properties
	[ValidateNotNullOrEmpty()]
	[System.String]
	$Name

	[ScriptBlock]
	$PreCheckScript

	[ValidateNotNullOrEmpty()]
	[ScriptBlock]
	$CheckScript

	# Constructors
	IAComplianceRule ([System.String] $Name, [ScriptBlock] $PreCheckScript, [ScriptBlock] $CheckScript) {
		$this.Name = $Name
		$this.PreCheckScript = $PreCheckScript
		$this.CheckScript = $CheckScript
	}
	IAComplianceRule ([System.String] $Name, [ScriptBlock] $CheckScript) {
		$this.Name = $Name
		$this.CheckScript = $CheckScript
	}

	# Methods
	[System.Boolean] ShouldBeChecked([Object] $InputObject) {
		if ($this.PreCheckScript) {
			return (Invoke-Command -ScriptBlock $this.PreCheckScript -InputObject $InputObject)
		} else {
			return $true
		}
	}
	[System.Boolean] Check([Object] $InputObject) {
		if ($this.ShouldBeChecked($InputObject)) {
			return (Invoke-Command -ScriptBlock $this.CheckScript -InputObject $InputObject)
		} else {
			return $null
		}
	}
	[System.String] ToString() {
		return $this.Name
	}
}

class IAComplianceCheck {
	# Properties
	[ValidateNotNullOrEmpty()]
	[System.String]
	$Name

	[ValidateNotNullOrEmpty()]
	[ScriptBlock]
	$InputScript

	[ValidateNotNullOrEmpty()]
	[System.Object[]]
	$Rules

	# Constructors
	IAComplianceCheck ([System.String] $Name, [ScriptBlock] $InputScript, [System.Object[]] $Rules) {
		$this.Name = $Name
		$this.InputScript = $InputScript
		foreach ($rule in $Rules) {
			if ($rule.GetType().Name -ne 'IAComplianceRule') {
				throw 'Rules must be IAComplianceRule objects.'
			}
		}
		$this.Rules = $Rules
	}

	# Methods
	[System.String] ToString() {
		return $this.Name
	}
}

class IAComplianceRuleCheckResult {
	# Properties
	[ValidateNotNullOrEmpty()]
	[IAComplianceCheck]
	$Check

	[ValidateNotNullOrEmpty()]
	[IAComplianceRule]
	$Rule

	[ValidateNotNullOrEmpty()]
	[System.Object]
	$Object

	[System.Boolean]
	$IsCompliant

	# Constructors
	IAComplianceRuleCheckResult ([IAComplianceCheck]$Check, [IAComplianceRule]$Rule, [System.Object]$Object, [System.Boolean] $IsCompliant) {
		$this.Check = $Check
		$this.Rule = $Rule
		$this.Object = $Object
		$this.IsCompliant = $IsCompliant
	}

	# Methods
	[System.String] ToString() {
		return ('{0} complies with "{1}" in "{2}"' -f $this.Object, $this.Rule.Name, $this.Check.Name)
	}
}

class IAComplianceReport {
	# Properties
	[ValidateNotNullOrEmpty()]
	[System.String]
	$Name

	[ValidateNotNullOrEmpty()]
	[IAComplianceRuleCheckResult[]]
	$Results

	IAComplianceReport ([System.String] $Name, [IAComplianceRuleCheckResult[]] $Results){
		$this.Name = $Name
		$this.Results = $Results
	}

	# Methods
	[System.String] ToString() {
		return ('{0}' -f $this.Name)
	}
}
