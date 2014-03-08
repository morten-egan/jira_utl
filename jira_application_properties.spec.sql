create or replace package jira_application_properties

as

	/** Package to integrate to the jira application-properties rest endpoint
	* @author Morten Egan
	* @version 0.0.1
	* @project JIRA_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	/** Pipelined function to get data about a specific application property
	* @author Morten Egan
	* @param key a String containing the property key
	* @param permission_level when fetching a list specifies the permission level of all items in the list see {@link com.atlassian.jira.bc.admin.ApplicationPropertiesService.EditPermissionLevel}
	* @param key_filter when fetching a list allows the list to be filtered by the property's start of key e.g. "jira.lf.*" whould fetch only those permissions that are editable and whose keys start with "jira.lf.". This is a regex.
	*/
	type property_rec is record (
		id						varchar2(250)
		, key					varchar2(250)
		, value					varchar2(4000)
		, name					varchar2(4000)
		, description			varchar2(4000)
		, type 					varchar2(4000)
		, default_value			varchar2(4000)
	);
	type property_rec_tab is table of property_rec;

	function get_property (
		key						in				varchar2 default null
		, permission_level		in				varchar2 default null
		, key_filter			in				varchar2 default null
	)
	return property_rec_tab
	pipelined;

	/** Set a property value
	* @author Morten Egan
	* @param id The property ID
	* @param prop_value The new value of the property
	*/
	procedure set_property (
		id						in				varchar2
		, prop_value			in				varchar2
	);

end jira_application_properties;
/