wheezy-dd-php5.3-coex-repackager
================================

Dirty, dirty scripts to re-package Dotdeb PHP 5.3 (Squeeze release) for Debian Wheezy.
The resulting package is also able to coexist with another PHP package from the official
Debian repository or dotdeb.org.

Build requirements
------------------

* fpm (https://github.com/jordansissel/fpm#get-with-the-download)


Installation requirements
-------------------------

To install the resulting package you need to have Debian Squeeze repository and Dotdeb Wheezy repository activated:

/etc/apt/sources.list:
  ...
  deb http://ftp.cz.debian.org/debian/ squeeze main
  deb http://packages.dotdeb.org wheezy all
