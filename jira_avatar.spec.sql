create or replace package jira_avatar

as

	/** Integration to Jira avatar REST endpoint
	* @author Morten Egan
	* @version 0.0.1
	* @project JIRA_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	/** Updates the cropping instructions of the temporary avatar
	* @author Morten Egan
	* @param avatar_type The avatar type
	*/
	procedure temporary_crop (
		avatar_type						in				varchar2
		, cropper_width					in				number
		, cropper_offset_x				in				number
		, cropper_offset_y				in				number
		, needs_cropping				in				boolean
	);

end jira_avatar;
/