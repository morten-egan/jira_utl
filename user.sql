create user jira_utl identified by jira_utl
default tablespace users
temporary tablespace temp
quota unlimited on users;

grant create session to jira_utl;
grant create procedure to jira_utl;
grant create type to jira_utl;