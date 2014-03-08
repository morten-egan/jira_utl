create or replace package body jira_avatar

as

	procedure temporary_crop (
		avatar_type						in				varchar2
		, cropper_width					in				number
		, cropper_offset_x				in				number
		, cropper_offset_y				in				number
		, needs_cropping				in				boolean
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('temporary_crop');

		jira.init_talk('auditing/settings', 'GET');
		jira.talk;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end temporary_crop;

begin

	dbms_application_info.set_client_info('jira_avatar');
	dbms_session.set_identifier('jira_avatar');

end jira_avatar;
/