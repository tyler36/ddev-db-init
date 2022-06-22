# tyler36/ddev-db-init <!-- omit in toc -->

[![tests](https://github.com/tyler36/ddev-db-init/actions/workflows/tests.yml/badge.svg)](https://github.com/tyler36/ddev-db-init/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2022.svg)

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [What does this add-on do and add?](#what-does-this-add-on-do-and-add)
- [Guides](#guides)
- [Reset the DDEV database service](#reset-the-ddev-database-service)
- [Supported SQL-files](#supported-sql-files)
  - [Postgres](#postgres)
  - [MariaDB](#mariadb)
  - [MySQL](#mysql)
- [TODO](#todo)

## Introduction

This add-on will automatically run SQL-like files when initializing the DDEV database service for the first time. See [offical Queues documentation](https://laravel.com/docs/9.x/queues) for more details.

This can be used to:

- configure the database service
- add additional databases
- populate the database

In addition, this makes it easy to

- reset the database service using `ddev export` and `ddev delete`
- configure the database of a cloud service such as Gitpod

## Getting Started

This add-on requires DDEV v1.19.3 or higher.

- Install the DDEV db-init add-on:

```shell
ddev get tyler36/ddev-db-init
ddev restart
```

## What does this add-on do and add?

1. Checks to make sure the DDEV version is adequate.
2. Adds `.ddev/docker-compose.db-init.yaml`, which mounts a ddev folder into the database container.

## Guides

## Reset the DDEV database service

- Create a backup of the current database.

```shell
ddev export-db --gzip=false -f db.sql
```

- Move the file into `.ddev/db-init`.

```shell
mv db.sql ./.ddev/db-init
```

- Destroy the DDEV database (you created a backup, didn't you?).

```shell
ddev delete -Oy
```

- Recreate the DDEV services.

```shell
ddev start
```

## Supported SQL-files

### Postgres

- *.sql
- *.sql.gz
- *.sh

See [Initialization Scripts](https://hub.docker.com/_/postgres) for further information.

### MariaDB

- *.sh,
- *.sql
- *.sql.gz
- *.sql.xz
- *.sql.zst

See [Initializing a fresh instance](https://hub.docker.com/_/mariadb) for further information.

### MySQL

- *.sh,
- *.sql
- *.sql.gz

See [Initializing a fresh instance](https://hub.docker.com/_/mysql) for further information.

## TODO

- [ ] Confirm MariaDb support
- [ ] Confirm MySQL support

**Contributed and maintained by [tyler36](https://github.com/tyler36)**
