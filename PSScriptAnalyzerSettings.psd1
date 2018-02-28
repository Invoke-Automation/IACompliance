@{
    ExcludeRules=@(
			'PSUseDeclaredVarsMoreThanAssignments', # This rule sometimes has false positives when nesting
			'PSAvoidUsingWriteHost', # This is by design, we want to output the compliance report to the host
			'PSAvoidUsingCmdletAliases', # This is by design, we want the option of a readable report script
			'PSUseShouldProcessForStateChangingFunctions' # No States will be changed
		)
}