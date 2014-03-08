create or replace package body jira_auditing

as

	function auditing_enabled
	return boolean
	
	as
	
		l_ret_val			boolean;
	
	begin
	
		dbms_application_info.set_action('auditing_enabled');

		jira.init_talk('auditing/settings', 'GET');
		jira.talk;

		l_ret_val := json_ext.get_bool(jira.jira_response_result.result, 'enabled');
	
		dbms_application_info.set_action(null);
	
		return l_ret_val;
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end auditing_enabled;

begin

	dbms_application_info.set_client_info('jira_auditing');
	dbms_session.set_identifier('jira_auditing');

end jira_auditing;
/