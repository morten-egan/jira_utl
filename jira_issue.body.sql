create or replace package body jira_issue

as

	procedure create_issue (
		project						in		varchar2
		, issuetype					in		varchar2
		, summary					in		varchar2
		, description				in		varchar2
		, parent					in		varchar2 default null
	)
	
	as

		build_json					json := json();
		temp_json					json := json();
	
	begin
	
		jira.init_talk('issue/', 'POST');

		if jira_help.is_number(project) then
			temp_json.put('id', project);
		else
			temp_json.put('key', project);
		end if;
		build_json.put('project', temp_json);

		if parent is not null then
			temp_json := json();
			temp_json.put('key', parent);
		end if;
		build_json.put('parent', temp_json);
		
		build_json.put('summary', summary);
		build_json.put('description', description);

		temp_json := json();
		if jira_help.is_number(issuetype) then
			temp_json.put('id', issuetype);
		else
			temp_json.put('name', issuetype);
		end if;
		build_json.put('issuetype', temp_json);

		jira.jira_call_request.call_json.put('fields', build_json);

		jira.talk;

		jira_help.jira_last_issue_id := json_ext.get_string(jira.jira_response_result.result, 'id');
		jira_help.jira_last_issue_key := json_ext.get_string(jira.jira_response_result.result, 'key');
		jira_help.jira_last_issue_ref := json_ext.get_string(jira.jira_response_result.result, 'self');
	
	end create_issue;

begin

	sys.dbms_application_info.set_client_info('jira_issue');
	sys.dbms_session.set_identifier('jira_issue');

end jira_issue;
/