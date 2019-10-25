class controller_rocky::configure_openidc inherits controller_rocky::params {

  package { "mod_auth_openidc":
    ensure  => present,
  }
  
  file { "/etc/httpd/conf.d/auth_openidc.conf":
    ensure   => file,
    owner    => "apache",
    group    => "apache",
    mode     => '0640',
    content  => template("controller_rocky/openidc.conf.erb"),
    tag      => ["oidc_conf"],
  }

  file { "/var/cache/httpd/mod_auth_openidc":
    ensure  => directory,
    owner   => "apache",
    group   => "apache",
    mode    => '0770',
  }

  file { "/var/cache/httpd/mod_auth_openidc/metadata":
    ensure  => directory,
    owner   => "apache",
    group   => "apache",
    mode    => '0770',
    require => File["/var/cache/httpd/mod_auth_openidc"],
  }

  create_resources(controller_rocky::oidc_provider, $oidc_providers)

  Package["mod_auth_openidc"] -> File <| tag == 'oidc_conf' |>

}
