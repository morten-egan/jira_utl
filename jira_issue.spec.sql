create or replace package jira_issue

as

	/** Oracle integration to Jira issues
	* @author Morten Egan
	* @version 0.0.1
	* @project JIRA_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	procedure create_issue (
		project						in		varchar2
		, issuetype					in		varchar2
		, summary					in		varchar2
		, description				in		varchar2
		, parent					in		varchar2 default null
	);

end jira_issue;
/