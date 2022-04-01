

$mysql_pass = "superpass"
Package { ensure => 'installed' }
$lamp = [ 'apache2', 'mysql-server', 'php']
$wordpress = ['ghostscript', 'libapache2-mod-php','php-bcmath','php-curl','php-imagick','php-intl',
'php-json','php-mbstring','php-mysql','php-xml','php-zip']
$mods = ['']
package {$lamp:}
package {$wordpress:}


file { '/srv/www':
  path => '/srv/www',
  ensure => directory,
  recurse => true,
  owner => 'www-data',
  max_files => 50000
}

archive { 'Download and untar wordpress':
  path => "/tmp/latest.tar.gz",
  source => 'https://wordpress.org/latest.tar.gz',
  user   => 'www-data',
  extract => true,
  extract_path => '/srv/www',
  creates => '/srv/www/wordpress',
}

file { 'Copy wordress.conf to apache sites-available':
  path => "/etc/apache2/sites-available/wordpress.conf",
  ensure => "file",
  source => "/vagrant/files/apache/wordpress.conf",
  owner => "www-data",
  replace => true,

}

exec { 'enable apache rewrite module':
  command => ['/usr/sbin/a2enmod','rewrite'],
}
exec { 'enable wordpress website':
  command => ['/usr/sbin/a2ensite','wordpress'],
}
exec { 'disable default apache website':
  command => ['/usr/sbin/a2dissite','000-default'],
}


mysql::db { 'wordpress':
  user => 'wordpress',
  password => $mysql_pass,
  host => 'localhost',
  grant => 'ALL',
  sql => "/vagrant/files/mysql/wordpressdump.sql"
}

# exec { 'Import database dump':
#   command => ['/usr/bin/sudo', "mysql wordpress < /vagrant/files/mysql/wordpressdump.sql"],
#   require => mysql::db['wordpress'],
# }

file { 'Copy wordpress config':
  path => "/srv/www/wordpress/wp-config.php",
  ensure => "file",
  source => "/srv/www/wordpress/wp-config-sample.php",
  owner => "www-data",
  replace => true,
}

file_line { 'Write database name to wordpress config':
  ensure => present,
  path   => '/srv/www/wordpress/wp-config.php',
  line   => "define( 'DB_NAME', 'wordpress' );",
  match  => "^define\(\ 'DB_NAME', 'database_name_",

}
file_line { 'Write user name to wordpress config':
  ensure => present,
  path   => '/srv/www/wordpress/wp-config.php',
  line   => "define( 'DB_USER', 'wordpress' );",
  match  => "^define\(\ 'DB_USER', 'username_",
  multiple => true,

}
file_line { 'Write password config':
  ensure => present,
  path   => '/srv/www/wordpress/wp-config.php',
  line   => "define( 'DB_PASSWORD', '${mysql_pass}' );",
  match  => "^define\(\ 'DB_PASSWORD', 'password",
  multiple => true,
  notify => Service['enable and start apache'],
}

service { 'enable and start apache':
  name => 'apache2',
  ensure => 'running',
  enable => true,
  require => FILE_LINE['Write password config'],
}

exec { 'reload apache':
  command => ['/usr/bin/sudo','/etc/init.d/apache2 reload']
}
