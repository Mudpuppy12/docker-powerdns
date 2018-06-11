#!/bin/sh
set -e

# --help, --version
[ "$1" = "--help" ] || [ "$1" = "--version" ] && exec pdns_server $1
# treat everything except -- as exec cmd
[ "${1:0:2}" != "--" ] && exec "$@"

#Check if Database is created

if [[ ! -e /etc/pdns/pdns.db ]]; then
  echo Creating sqlite3 Database
  sqlite3 /etc/pdns/pdns.db < /etc/pdns/sqlite3.sql
  chown pdns /etc/pdns
  chown pdns /etc/pdns/pdns.db
fi


# Run pdns server
trap "pdns_control quit" SIGHUP SIGINT SIGTERM

pdns_server "$@" &

wait
