#!/bin/bash
set -e

# Download original DotDeb packages
mkdir -p src
wget -Adeb -r -l1 -nd -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/

VERSION=`find src/php5-cli*.deb | sed -nr 's/^src\/php5-cli_([^~]+).+$/\1/p'`

rm -rf tmp
mkdir tmp
cd tmp
for deb in `find ../src -name '*.deb'`; do
    [[ $deb =~ php5-deb ]] && continue
    [[ $deb =~ php5-dbg ]] && continue
    [[ $deb =~ libapache ]] && continue
    ar x "$deb" data.tar.gz || true
    tar xfz data.tar.gz
    rm data.tar.gz
done

mv etc/cron.d/php5 etc/cron.d/php53
sed -i s/php5/php53/ etc/cron.d/php53
mv etc/init.d/php5-fpm etc/init.d/php53-fpm
mv etc/php5 etc/php53
mv usr/bin/php5 usr/bin/php53
mv usr/bin/php5-cgi usr/bin/php53-cgi
mv usr/lib/cgi-bin/php5 usr/lib/cgi-bin/php53
rmdir usr/lib/php5/libexec
#rm usr/lib/php5/maxlifetime
mv usr/sbin/php5-fpm usr/sbin/php53-fpm
rm -rf usr/share/doc
rm -rf usr/share/lintian
rm -rf usr/share/man
mv usr/share/php5 usr/share/php53
mv var/lib/php5 var/lib/php53

fpm -s dir \
    -t deb \
    -n php53-coex \
    -v $VERSION \
    --config-files /usr/lib/php5/maxlifetime \
    --config-files /etc/php53/fpm/pool.d/www.conf \
    --config-files /etc/php53/fpm/php-fpm.conf \
    --config-files /etc/php53/conf.d/curl.ini \
    --config-files /etc/php53/conf.d/enchant.ini \
    --config-files /etc/php53/conf.d/gd.ini \
    --config-files /etc/php53/conf.d/gmp.ini \
    --config-files /etc/php53/conf.d/imap.ini \
    --config-files /etc/php53/conf.d/interbase.ini \
    --config-files /etc/php53/conf.d/intl.ini \
    --config-files /etc/php53/conf.d/ldap.ini \
    --config-files /etc/php53/conf.d/mcrypt.ini \
    --config-files /etc/php53/conf.d/mssql.ini \
    --config-files /etc/php53/conf.d/mysqli.ini \
    --config-files /etc/php53/conf.d/mysql.ini \
    --config-files /etc/php53/conf.d/odbc.ini \
    --config-files /etc/php53/conf.d/pdo_dblib.ini \
    --config-files /etc/php53/conf.d/pdo_firebird.ini \
    --config-files /etc/php53/conf.d/pdo.ini \
    --config-files /etc/php53/conf.d/pdo_mysql.ini \
    --config-files /etc/php53/conf.d/pdo_odbc.ini \
    --config-files /etc/php53/conf.d/pdo_pgsql.ini \
    --config-files /etc/php53/conf.d/pdo_sqlite.ini \
    --config-files /etc/php53/conf.d/pgsql.ini \
    --config-files /etc/php53/conf.d/pspell.ini \
    --config-files /etc/php53/conf.d/recode.ini \
    --config-files /etc/php53/conf.d/snmp.ini \
    --config-files /etc/php53/conf.d/sqlite3.ini \
    --config-files /etc/php53/conf.d/sqlite.ini \
    --config-files /etc/php53/conf.d/tidy.ini \
    --config-files /etc/php53/conf.d/xmlrpc.ini \
    --config-files /etc/php53/conf.d/xsl.ini \
    *

mv *.deb ..

# vim:set ts=4 sw=4 sts=4 et:
