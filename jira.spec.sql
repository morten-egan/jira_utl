create or replace package jira

as

	/** Jira API communication
	* @author Morten Egan
	* @project JIRA_UTL
	* @version 0.0.1
	*/

	-- Types and globals
	-- Global variables and types
	type session_settings is record (
		transport_protocol			varchar2(4000)
		, jira_host					varchar2(4000)
		, jira_host_port			varchar2(4000)
		, jira_api_name				varchar2(4000)
		, jira_api_version			varchar2(4000)
		, wallet_location			varchar2(4000)
		, wallet_password			varchar2(4000)
		, jira_user 				varchar2(4000)
		, jira_password				varchar2(4000)
	);

	jira_session					session_settings;

	type call_request is record (
		call_endpoint				varchar2(4000)
		, call_method				varchar2(100)
		, call_json					json
	);
	jira_call_request				call_request;

	type call_result is record (
		result_type					varchar2(200)
		, result 					json
		, result_list				json_list
	);
	jira_response_result			call_result;

	jira_api_raw_result				clob;
	jira_call_status_code			pls_integer;
	jira_call_status_reason			varchar2(256);

	type text_text_arr is table of varchar2(4000) index by varchar2(250);
	jira_response_headers			text_text_arr;

	procedure session_setup (
		transport_protocol			varchar2
		, jira_host					varchar2
		, jira_host_port			varchar2
		, jira_api_name				varchar2
		, jira_api_version			varchar2
		, wallet_location			varchar2
		, wallet_password			varchar2
		, jira_user 				varchar2
		, jira_password				varchar2
	);

	/** Send request to Jira API
	* @author Morten Egan
	*/
	procedure talk;

end jira;
/