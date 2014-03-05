create or replace package body jira

as

	procedure session_setup (
		transport_protocol			varchar2 default null
		, jira_host					varchar2 default null
		, jira_host_port			varchar2 default null
		, jira_api_name				varchar2 default null
		, jira_api_version			varchar2 default null
		, wallet_location			varchar2 default null
		, wallet_password			varchar2 default null
		, jira_user 				varchar2 default null
		, jira_password				varchar2 default null
	)

	as

	begin

		if transport_protocol is not null then
			jira_session.transport_protocol := transport_protocol;
		end if;

		if jira_host is not null then
			jira_session.jira_host := jira_host;
		end if;

		if jira_host_port is not null then
			jira_session.jira_host_port := jira_host_port;
		end if;

		if jira_api_name is not null then
			jira_session.jira_api_name := jira_api_name;
		end if;

		if jira_api_version is not null then
			jira_session.jira_api_version := jira_api_version;
		end if;

		if wallet_location is not null then
			jira_session.wallet_location := wallet_location;
		end if;

		if wallet_password is not null then
			jira_session.wallet_password := wallet_password;
		end if;

		if jira_user is not null then
			jira_session.jira_user := jira_user;
		end if;

		if jira_password is not null then
			jira_session.jira_password := jira_password;
		end if;

	end session_setup;

	procedure parse_jira_result

	as

	begin

		if substr(jira_api_raw_result, 1 , 1) = '[' then
			jira_call_result.result_type := 'JSON_LIST';
			jira_call_result.result_list := json_list(jira_api_raw_result);
		else
			jira_call_result.result_type := 'JSON';
			jira_call_result.result := json(jira_api_raw_result);
		end if;

	end parse_jira_result;

	procedure talk

	as

		jira_request				utl_http.req;
		jira_response				utl_http.resp;
		jira_result_piece			varchar2(32000);

		jira_header_name			varchar2(4000);
		jira_header_value			varchar2(4000);

		session_setup_error			exception;
		pragma exception_init(session_setup_error, -20001);

	begin

		-- Always reset result
		jira.jira_api_raw_result := null;

		-- Extended error checking
		utl_http.set_response_error_check(
			enable => true
		);
		utl_http.set_detailed_excp_support(
			enable => true
		);

		if jira_session.transport_protocol is not null then
			if jira_session.transport_protocol = 'HTTPS' then
				utl_http.set_wallet(
					jira_session.wallet_location
					, jira_session.wallet_password
				);
			end if;
		else
			raise_application_error(-20001, 'Transport protocol is not defined');
		end if;

		utl_http.set_follow_redirect (
			max_redirects => 1
		);

		if jira_session.jira_host is not null and jira_session.jira_host_port is not null and jira_session.jira_api_name is not null and jira_session.jira_api_version is not null then
			jira_request := utl_http.begin_request(
				url => jira_session.transport_protocol || '://' || jira_session.jira_host || ':' || jira_session.jira_host_port || '/' || jira_session.jira_api_name || '/' || jira_session.jira_api_version || '/' || jira_call_request.call_endpoint
				, method => jira_call_request.call_method
			);
		else
			raise_application_error(-20001, 'Jira site parameters invalid');
		end if;

		if jira_session.jira_user is not null and jira_session.jira_password is not null then
			-- Set authentication and headers
			utl_http.set_authentication(
				r => jira_request
				, username => jira_session.jira_user
				, password => jira_session.jira_password
				, scheme => 'Basic'
				, for_proxy => false
			);
			utl_http.set_header(
				r => jira_request
				, name => 'User-Agent'
				, value => 'JIRA_UTL Oracle pkg - ' || jira_session.jira_user
			);
		else
			raise_application_error(-20001, 'Jira logon information not setup');
		end if;

		-- Method specific headers
		if (length(jira_call_request.call_json.to_char) > 4) then
			utl_http.set_header(
				r => jira_request
				, name => 'Content-Type'
				, value => 'application/json'
			);
			utl_http.set_header(
				r => jira_request
				, name => 'Content-Length'
				, value => length(jira_call_request.call_json.to_char)
			);
			-- Write the content
			utl_http.write_text (
				r => jira_request
				, data => jira_call_request.call_json.to_char
			);
		end if;

		jira_response := utl_http.get_response (
			r => jira_request
		);

		-- Should handle exceptions here
		jira_call_status_code := jira_response.status_code;
		jira_call_status_reason := jira_response.reason_phrase;

		-- Load header data before reading body
		for i in 1..utl_http.get_header_count(r => jira_response) loop
			utl_http.get_header(
				r => jira_response
				, n => i
				, name => jira_header_name
				, value => jira_header_value
			);
			jira_response_headers(jira_header_name) := jira_header_value;
		end loop;

		-- Collect response and put into api_result
		begin
			loop
				utl_http.read_text (
					r => jira_response
					, data => jira_result_piece
				);
				jira_api_raw_result := jira_api_raw_result || jira_result_piece;
			end loop;

			exception
				when utl_http.end_of_body then
					null;
				when others then
					raise;
		end;

		utl_http.end_response(
			r => jira_response
		);

		-- Parse result into json
		parse_jira_result;

	end talk;

	procedure init_talk (
		endpoint 				varchar2
		, endpoint_method		varchar2 default 'GET'
	)
	
	as
	
	begin
	
		jira_call_request.call_endpoint := endpoint;
		jira_call_request.call_method := endpoint_method;
		jira_call_request.call_json := json();
	
	end init_talk;
	
end jira;
/