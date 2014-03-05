create or replace package body jira_help

as

	function is_number(
		str					in				varchar2
	)
	return boolean

	as

		is_num				number;

	begin

		is_num := to_number(str);
		return true;

		exception
			when others then
				return false;

	end is_number;

begin

	sys.dbms_application_info.set_client_info('jira_help');
	sys.dbms_session.set_identifier('jira_help');

end jira_help;
/