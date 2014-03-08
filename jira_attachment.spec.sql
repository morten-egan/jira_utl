create or replace package jira_attachment

as

	/** Integration to the Jira attachment rest endpoints
	* @author Morten Egan
	* @version 0.0.1
	* @project JIRA_UTL
	*/
	p_version		varchar2(50) := '0.0.1';

	/** Pipelined function to get attachment meta information
	* @author Morten Egan
	* @param att_id Id if the attachment
	*/
	type attachment_rec is record (
		filename					varchar2(4000)
		, author_name				varchar2(4000)
		, author_link				varchar2(4000)
		, created					varchar2(4000)
		, att_size					number
		, mimetype					varchar2(4000)
		, content					varchar2(4000)
		, thumbnail					varchar2(4000)
	);
	type attachment_rec_tab is table of attachment_rec;

	function get_attachment (
		att_id						in				varchar2
	)
	return attachment_rec_tab
	pipelined;

	/** Delete attachment
	* @author Morten Egan
	* @param att_id The id of the attachment to delete
	*/
	procedure delete_attachment (
		att_id						in				varchar2
	);

	/** Get attachments meta information
	* @author Morten Egan
	*/
	type attachment_meta_rec is record (
		enabled						varchar2(4000)
		, upload_limit				number
	);
	type attachment_meta_rec_tab is table of attachment_meta_rec;

	function get_attachment_meta
	return attachment_meta_rec_tab
	pipelined;

end jira_attachment;
/