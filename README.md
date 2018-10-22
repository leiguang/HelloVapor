<p align="center">
    <img src="https://user-images.githubusercontent.com/1342803/36623515-7293b4ec-18d3-11e8-85ab-4e2f8fb38fbd.png" width="320" alt="API Template">
    <br>
    <br>
    <a href="http://docs.vapor.codes/3.0/">
        <img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
    </a>
    <a href="https://discord.gg/vapor">
        <img src="https://img.shields.io/discord/431917998102675485.svg" alt="Team Chat">
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/api-template">
        <img src="https://circleci.com/gh/vapor/api-template.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-4.1-brightgreen.svg" alt="Swift 4.1">
    </a>
</p>


#### Terminal操作
1. 查看端口被哪个程序占用：*lsof -i :port*
    如：*lsof -i :8080*
2. 查看某j进程的pid，如mysql：*ps -ef | grep mysql*
3. 强制杀死某进程：kill -9 PID
    [Linux kill -9 和 kill -15 的区别](https://www.cnblogs.com/liuhouhou/p/5400540.html)
    (Stop the MySQL server by sending a normal kill (not kill -9) to the mysqld process. )


#### Docker中安装MySQL
1. 截至我安装mysql-server的时候，需要指定其版本为5.7，See: https://github.com/vapor/fluent-mysql/issues/110
否则会报错：Fatal error: Error raised at top level: ⚠️ MySQL Error: Unsupported auth plugin: caching_sha2_password
Resolution:
```
docker stop mysql
docker rm mysql
docker run --name mysql -e MYSQL_USER=leiguang -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=vapor -p 3306:3306 -d mysql/mysql-server:5.7
```

2. 导出docker中的mysql数据库
示例如：*docker exec 'mysql' mysqldump -u 'leiguang' --password='password' 'vapor' > '/Users/lg/Desktop/mysql_backup.sql'*
其中 'mysql': Container名。  'leiguang': 数据库的用户名。  'password': 数据库的密码。 'vapor'数据库名。 '/Users/lg/Desktop/mysql_backup.sql': 导出到的本机路径，注意要先在改路径上创建一个 .sql结尾的文件，再执行导出操作。


#### Mac上安装MySQL
1. [MySQL官网下载(最新版)](https://dev.mysql.com/downloads/mysql/)，或 [5.7版](https://dev.mysql.com/downloads/mysql/5.7.html#downloads)
2. [MySQL安装步骤](https://dev.mysql.com/doc/refman/5.7/en/osx-installation.html)
3. MySQL安装完成后，会自动创建一个 */usr/local/mysql-5.7.23-macos10.13-x86_64* 的软链接：*/usr/local/mysql*
> [During the package installer process, a symbolic link from /usr/local/mysql to the version/platform specific directory created during installation will be created automatically. ](https://dev.mysql.com/doc/refman/5.7/en/osx-installation-pkg.html)


4. 我的电脑上安装完成后，使用 *mysql --version*, 会提示 *-bash: mysql: command not found*， 但是当我使用 "/usr/local/mysql/bin/mysql --version" 却能正确执行。
    解决办法：执行命令 `echo 'export PATH=$PATH:/usr/local/mysql/bin' >> ~/.bash_profile` 和 `source ~/.bash_profile`
        （注意 如果只写 *export PATH=$PATH:/usr/local/mysql/bin*，这种方仅对f当期命令行窗口有效，当前窗口关闭后即无效了）
    原因：If mysql is in /usr/local/mysql/bin rather than /usr/local/bin then update your PATH。详见[Stack Overflow](https://stackoverflow.com/questions/26554818/using-mysql-in-the-command-line-in-osx-command-not-found)

5. MySQL安装完成后，在 /usr/local/mysql-5.7.23-macos10.13-x86_64 下的目录结构如下：
> [Table 2.6 MySQL Installation Layout on macOS](https://dev.mysql.com/doc/refman/5.7/en/osx-installation-pkg.html)
Directory    Contents of Directory
bin    mysqld server, client and utility programs
data    Log files, databases
docs    Helper documents, like the Release Notes and build information
include    Include (header) files
lib    Libraries
man    Unix manual pages
mysql-test    MySQL test suite
share    Miscellaneous support files, including error messages, sample configuration files, SQL for database installation
support-files    Scripts and sample configuration files
/tmp/mysql.sock    Location of the MySQL Unix socket

6. 由于我是下载dmg直接安装的，安装过程中，[系统会提示给出一个root账户的初始密码](https://dev.mysql.com/doc/refman/5.7/en/osx-installation-pkg.html)，先记下它。 安装完成后，执行 *mysql -u root -p*，输入该初始密码，进入 mysql> ，不同MySQL版本分别执行以下语句来[修改密码](https://dev.mysql.com/doc/refman/5.7/en/resetting-permissions.html)
    MySQL 5.7.6 and later:    
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';
    
    MySQL 5.7.5 and earlier:
    SET PASSWORD FOR 'root'@'localhost' = PASSWORD('MyNewPass');


#### MySQL基本操作
[极客学院视频](https://www.jikexueyuan.com/course/627_6.html?ss=1)
```
// 创建表
CREATE TABLE user (
user_name VARCHAR(20),
age INT,
signup_date DATE
);

// 插入一条数据
insert into user values('leiguang', '25', '2018-10-18');

// 查询所有数据
select * from user;

// 查询所有数据，只获取其中的指定字段
select user_name, age, signup_date from user;

// 查询 指定条件 的数据
select * from user where user_name = 'leiguang';

// 查询 指定多个条件 的数据
select * from user where user_name = 'leiguang' and age = 25;

// 更新指定条件的数据
update tbl_user set age = 30 where user_name = 'darkmi';

// 删除指定条件的数据
delete from user where user_name = 'leiguang';

// 添加字段
alter table user add email varchar(50);

// 删除字段
alter table tbl_user drop email;

// 修改字段名
alter table tbl_user change age user_age int;

// 修改 字段的类型定义
alter table tbl_user change user_age user_age tinyint(1) not null;

// 修改表名
alter table tbl_user rename user_tbl;

// 删除表
drop table user_tbl;
```



