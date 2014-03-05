create or replace package jira_issue

as

	/** Oracle integration to Jira issues
	* @author Morten Egan
	* @version 0.0.1
	* @project JIRA_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	-- Customfield type
	type jira_issue_custom_field is record (
		field_id					number
		, field_value_string		clob
		, field_value_json			json
		, field_value_json_list		json_list
	);
	type jira_customfield_list is table of jira_issue_custom_field;

	procedure create_issue (
		project						in		varchar2
		, issuetype					in		varchar2
		, summary					in		varchar2
		, description				in		varchar2
		, parent					in		varchar2 default null
		, custom_fields				in 		jira_customfield_list default jira_customfield_list()
	);

end jira_issue;
/