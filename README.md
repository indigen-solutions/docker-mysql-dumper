# mysql-dumper

This docker image allows you to scan and mysqldump databases on all the running MySQL containers.

## Usage

```
  docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/backups:/mnt indigen/mysql-dumper 2015-07-14T16:42:21
```

Dump all the register MySQL containers and dumps them in /tmp/backups/2015-07-14T16:42:21
In order to get informations from running containers you must expose the docker socket with `-v /var/run/docker.sock:/var/run/docker.sock`

## Options

You can set various options on MySQL running containers.

  - **MYSQL_DUMPER** *(mandatory)* : This variable allow you to specify the database you want to dump on this container. You can specify multiple databases separated by a comma. If you don't set this variable, none of the databases will be dumped.
  - **MYSQL_DUMPER_PORT** *(optional)* : Specify the mysql port to use (default: 3306)
  - **MYSQL_DUMPER_USER** *(optional)* : Specify the mysql user to use (default: root)
  - **MYSQL_DUMPER_PASSWORD** *(optional)* : Specify the MySQL password to use. If this variable is not set it will look for MYSQL_ROOT_PASSWORD environment variables. If none of this variables are set it will try to connect without password.
  - **MYSQL_DUMPER_OPTIONS** *(optional)* : Specify options to pass to mysql-dump command.

## Exemple of a MySQL container
```
mysql:
  image: mysql
  environment:
    - MYSQL_ROOT_PASSWORD=password
    - MYSQL_DATABASE=wordpress
    - MYSQL_DUMPER=wordpress,mysql
    - MYSQL_DUMPER_PORT=3306
    - MYSQL_DUMPER_USER=root
    - MYSQL_DUMPER_PASSWORD=password
    - MYSQL_DUMPER_OPTIONS=--lock-all-tables
  expose:
    - 3306
```