create or replace package body jira_attachment

as

	function get_attachment (
		att_id					in				varchar2
	)
	return attachment_rec_tab
	pipelined
	
	as
	
		row_data			attachment_rec;
	
	begin
	
		dbms_application_info.set_action('get_attachment');

		jira.init_talk('attachment/', 'GET');
		jira.jira_call_request.call_json.put('id', att_id);
		jira.talk;

		row_data.filename := json_ext.get_string(jira.jira_response_result.result, 'filename');
		row_data.author_name := json_ext.get_string(jira.jira_response_result.result, 'author.displayName');
		row_data.author_link := json_ext.get_string(jira.jira_response_result.result, 'author.self');
		row_data.created := json_ext.get_string(jira.jira_response_result.result, 'created');
		row_data.att_size := json_ext.get_number(jira.jira_response_result.result, 'size');
		row_data.mimetype := json_ext.get_string(jira.jira_response_result.result, 'mimeType');
		row_data.content := json_ext.get_string(jira.jira_response_result.result, 'content');
		row_data.thumbnail := json_ext.get_string(jira.jira_response_result.result, 'thumbnail');

		pipe row(row_data);
	
		dbms_application_info.set_action(null);
	
		return;
	
	end get_attachment;

	procedure delete_attachment (
		att_id						in				varchar2
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('delete_attachment');

		jira.init_talk('attachment/', 'DELETE');
		jira.jira_call_request.call_json.put('id', att_id);
		jira.talk;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end delete_attachment;

	function get_attachment_meta
	return attachment_meta_rec_tab
	pipelined
	
	as
	
		row_data			attachment_meta_rec;
	
	begin
	
		dbms_application_info.set_action('get_attachment_meta');

		jira.init_talk('attachment/meta', 'GET');
		jira.talk;

		row_data.enabled := json_ext.get_string(jira.jira_response_result.result, 'enabled');
		row_data.upload_limit := json_ext.get_string(jira.jira_response_result.result, 'uploadLimit');

		pipe row(row_data);
	
		dbms_application_info.set_action(null);
	
		return;
	
	end get_attachment_meta;

begin

	dbms_application_info.set_client_info('jira_attachment');
	dbms_session.set_identifier('jira_attachment');

end jira_attachment;
/