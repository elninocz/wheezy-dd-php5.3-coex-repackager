#!/bin/bash
set -e

VERSION="5.3.27-1"

# Download original DotDeb packages
mkdir -p src
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-cgi_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-cli_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-common_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-curl_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-fpm_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-gd_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-imap_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-intl_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-mcrypt_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-mysql_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-sqlite_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-xmlrpc_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5/binary-amd64/php5-xsl_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5-pecl/binary-amd64/php5-apc_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5-pecl/binary-amd64/php5-imagick_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5-pecl/binary-amd64/php5-memcache_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5-pecl/binary-amd64/php5-memcached_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5-pecl/binary-amd64/php5-suhosin_$VERSION~dotdeb.0_amd64.deb
wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5-pecl/binary-amd64/php5-xdebug_$VERSION~dotdeb.0_amd64.deb
#wget -c -P src/ http://packages.dotdeb.org/dists/squeeze/php5-pecl/binary-amd64/php5-xhprof_$VERSION~dotdeb.0_amd64.deb

rm -rf tmp
mkdir tmp
cd tmp
for deb in `find ../src -name '*.deb'`; do
    ar x "$deb" data.tar.gz || true
    tar xfz data.tar.gz
    rm data.tar.gz
done

mv etc/cron.d/php5 etc/cron.d/php53
sed -i 's#var/lib/php5#var/lib/php53#g; s#/maxlifetime#/maxlifetime53#g;' etc/cron.d/php53
mv etc/init.d/php5-fpm etc/init.d/php53-fpm
mv etc/php5 etc/php53
mv usr/bin/php5 usr/bin/php53.real
cp ../scripts/php53 usr/bin/php53
mv usr/bin/php5-cgi usr/bin/php53-cgi
mv usr/lib/cgi-bin/php5 usr/lib/cgi-bin/php53
mv usr/lib/php5/maxlifetime usr/lib/php5/maxlifetime53
rmdir usr/lib/php5/libexec
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
    -d libmemcached11 \
    -d libicu44 \
    -d "libmagickcore3 >= 8:6.6.0.4" \
    -d libmagickwand3 \
    -d "libsqlite0 >= 2.8.17" \
    -d "libsqlite3-0 >= 3.7.3" \
    -d libc-client2007e \
    -d "libxml2 >= 2.7.4" \
    -d "libxslt1.1" \
    --after-install ../scripts/postinst \
    --config-files /usr/lib/php5/maxlifetime53 \
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
    --config-files /etc/php53/conf.d/apc.ini \
    --config-files /etc/php53/conf.d/imagick.ini \
    --config-files /etc/php53/conf.d/memcache.ini \
    --config-files /etc/php53/conf.d/memcached.ini \
    --config-files /etc/php53/conf.d/xdebug.ini \
    --config-files /etc/php53/conf.d/xhprof.ini \
    *

mv *.deb ..

# vim:set ts=4 sw=4 sts=4 et:
