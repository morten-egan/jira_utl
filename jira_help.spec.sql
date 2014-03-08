create or replace package jira_help

as

	/** A helper package for the jira API integration
	* @author Morten Egan
	* @version 0.0.1
	* @project JIRA_UTL
	*/
	p_version				varchar2(50) := '0.0.1';
	jira_last_issue_id		number := null;
	jira_last_issue_key		varchar2(100) := null;
	jira_last_issue_ref		varchar2(4000) := null;

	function is_number(
		str					in				varchar2
	)
	return boolean;

	function get_last_issue_key
	return varchar2;

end jira_help;
/