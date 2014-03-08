create or replace package jira_auditing

as

	/** Integration to Jira auditing REST endpoint
	* @author Morten Egan
	* @version 0.0.1
	* @project JIRA_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	/** Check if auditing is enabled
	* @author Morten Egan
	* @param parm_name A description of the parameter
	*/
	function auditing_enabled
	return boolean;

end jira_auditing;
/