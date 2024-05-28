About 

This project can generate and run jobs of [Alibaba DataX](https://github.com/alibaba/DataX).

It was written by ansible playbook.

Now we can only support sync jobs of  `MySQL to MySQL`, it works like below

 - Dump database struct of MySQL reader
 - Create writer database struct by dump file
 - Register tables of database to Ansible playbook
 - Generate reader.json、writer.json、job.json
 - Run jobs by alibaba DataX to sync data from one to another

Features
 - Docker
 - 仅需简单配置即可全量同步mysql数据库，无需手动撰写job
 - 支持并发执行job

Parameters
 ```
 - hosts: localhost
  gather_facts: false
  vars:
    source: mysql
    table_register_sql: SELECT TABLE_NAME, CONCAT( 'SELECT * FROM ', TABLE_NAME, ' WHERE company_id = 108911;' ) `SQL`, ( SELECT CONCAT( '"`', GROUP_CONCAT( COLUMN_NAME ORDER BY ORDINAL_POSITION ASC SEPARATOR '`","`' ), '`"' ) FROM information_schema.COLUMNS c WHERE c.TABLE_SCHEMA = '{{writer_mysql_db}}' AND c.TABLE_NAME = t1.TABLE_NAME ) `COLUMNS` FROM information_schema.TABLES t1 WHERE t1.TABLE_SCHEMA = '{{writer_mysql_db}}' AND t1.TABLE_NAME IN ( SELECT TABLE_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{{writer_mysql_db}}' AND COLUMN_NAME = 'company_id' ) UNION ALL SELECT TABLE_NAME, CONCAT( 'SELECT * FROM ', TABLE_NAME, ';' ) `SQL`, ( SELECT CONCAT( '"`', GROUP_CONCAT( COLUMN_NAME ORDER BY ORDINAL_POSITION ASC SEPARATOR '`","`' ), '`"' ) FROM information_schema.COLUMNS c WHERE c.TABLE_SCHEMA = '{{writer_mysql_db}}' AND c.TABLE_NAME = t2.TABLE_NAME ) `COLUMNS` FROM information_schema.TABLES t2 WHERE t2.TABLE_SCHEMA = '{{writer_mysql_db}}' AND t2.TABLE_NAME NOT IN ( SELECT TABLE_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{{writer_mysql_db}}' AND COLUMN_NAME = 'company_id' );
    reader_mysql_host: 127.0.0.1
    reader_mysql_port: 3306
    reader_mysql_user: root
    reader_mysql_pass: myrootpass
    reader_mysql_db: test_db1
    writer_mysql_host: 127.0.0.1
    writer_mysql_port: 3306
    writer_mysql_user: root
    writer_mysql_pass: myrootpass
    writer_mysql_db: test_db1
    exclude_tables:
      - replies
      - attachments
      - taggings
      - ticket_follows
      - customer_stats
      - customer_feeds
      - alterations
  roles:
    - common
    - mysql
    - datax
 ```
 - source 数据源 
 - table_register_sql: 获取数据库中所有的表， 默认值为：
    ```
    SELECT TABLE_NAME, 
           ( SELECT CONCAT( '"`', GROUP_CONCAT( COLUMN_NAME ORDER BY ORDINAL_POSITION ASC SEPARATOR '`","`' ), '`"' ) FROM information_schema.COLUMNS c WHERE c.TABLE_SCHEMA = '{{writer_mysql_db}}' AND c.TABLE_NAME = t1.TABLE_NAME ) `COLUMNS` 
    FROM information_schema.TABLES t1 WHERE t1.TABLE_SCHEMA = '{{writer_mysql_db}}';   
    ```
 - exclude_tables: 排除表  
