BEGIN
	DBMS_NETWORK_ACL_ADMIN.drop_acl ( 
    acl         => 'jira_acl.xml');

  COMMIT;

  DBMS_NETWORK_ACL_ADMIN.create_acl (
    acl          => 'jira_acl.xml', 
    description  => 'ACL definition for Github.com access',
    principal    => 'JIRA_UTL',
    is_grant     => TRUE, 
    privilege    => 'connect',
    start_date   => SYSTIMESTAMP,
    end_date     => NULL);

  COMMIT;

dbms_network_acl_admin.add_privilege (
			acl	 => 'jira_acl.xml',
			principal	 => 'JIRA_UTL',
			is_grant	 => true,
			privilege	 => 'resolve'
		);
		commit;

		dbms_network_acl_admin.assign_acl (
			acl          => 'jira_acl.xml',
			host         => 'jira_host.mydomain',
			lower_port	 => 80,
			upper_port	 => null
		);
		commit;

  COMMIT;
END;
/