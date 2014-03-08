create or replace package body jira_application_properties

as

	function get_property (
		key						in				varchar2 default null
		, permission_level		in				varchar2 default null
		, key_filter			in				varchar2 default null
	)
	return property_rec_tab
	pipelined

	as

		row_data				property_rec;

	begin

		jira.init_talk('application-properties/', 'GET');
		if key is not null then
			jira.jira_call_request.call_json.put('key', key);
		end if;
		if permission_level is not null then
			jira.jira_call_request.call_json.put('permissionLevel', permission_level);
		end if;
		if key_filter is not null then
			jira.jira_call_request.call_json.put('keyFilter', key_filter);
		end if;

		jira.talk;

		row_data.id := json_ext.get_string(jira.jira_response_result.result, 'id');
		row_data.key := json_ext.get_string(jira.jira_response_result.result, 'key');
		row_data.value := json_ext.get_string(jira.jira_response_result.result, 'value');
		row_data.name := json_ext.get_string(jira.jira_response_result.result, 'name');
		row_data.description := json_ext.get_string(jira.jira_response_result.result, 'desc');
		row_data.type := json_ext.get_string(jira.jira_response_result.result, 'type');
		row_data.default_value := json_ext.get_string(jira.jira_response_result.result, 'defaultValue');

		pipe row(row_data);

		return;

	end get_property;

	procedure set_property (
		id						in				varchar2
		, prop_value			in				varchar2
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('set_property');

		jira.init_talk('application-properties/', 'PUT');

		jira.jira_call_request.call_json.put('id', id);
		jira.jira_call_request.call_json.put('value', prop_value);

		jira.talk;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end set_property;

begin

	sys.dbms_application_info.set_client_info('jira_application_properties');
	sys.dbms_session.set_identifier('jira_application_properties');

end jira_application_properties;
/