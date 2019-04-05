class controller_rocky::configure_shibboleth inherits controller_rocky::params {

  exec { "download_shib_repo":
    command => "/usr/bin/wget -q -O /etc/yum.repos.d/shibboleth.repo ${shib_repo_url}",
    creates => "/etc/yum.repos.d/shibboleth.repo",
  }
  
  package { "shibboleth":
    ensure  => present,
    require => Exec["download_shib_repo"],
  }
  
  file { "/etc/shibboleth/horizon-infn-key.pem":
    ensure   => file,
    owner    => "shibd",
    group    => "shibd",
    mode     => '0400',
    source   => "${host_key}",
    tag      => ["shibboleth_sec"],
  }

  file { "/etc/shibboleth/horizon-infn-cert.pem":
    ensure   => file,
    owner    => "shibd",
    group    => "shibd",
    mode     => '0600',
    source   => "${host_cert}",
    tag      => ["shibboleth_sec"],
  }

  file { "/etc/shibboleth/horizon-unipd-key.pem":
    ensure   => file,
    owner    => "shibd",
    group    => "shibd",
    mode     => '0400',
    source   => "${unipd_key}",
    tag      => ["shibboleth_sec"],
  }

  file { "/etc/shibboleth/horizon-unipd-cert.pem":
    ensure   => file,
    owner    => "shibd",
    group    => "shibd",
    mode     => '0600',
    source   => "${unipd_cert}",
    tag      => ["shibboleth_sec"],
  }

  file { "/etc/shibboleth/keystone-infn-key.pem":
    ensure   => file,
    owner    => "shibd",
    group    => "shibd",
    mode     => '0400',
    source   => "${keystone_infn_key}",
    tag      => ["shibboleth_sec"],
  }

  file { "/etc/shibboleth/keystone-infn-cert.pem":
    ensure   => file,
    owner    => "shibd",
    group    => "shibd",
    mode     => '0600',
    source   => "${keystone_infn_cert}",
    tag      => ["shibboleth_sec"],
  }

  file { "/etc/shibboleth/keystone-unipd-key.pem":
    ensure   => file,
    owner    => "shibd",
    group    => "shibd",
    mode     => '0400',
    source   => "${keystone_unipd_key}",
    tag      => ["shibboleth_sec"],
  }

  file { "/etc/shibboleth/keystone-unipd-cert.pem":
    ensure   => file,
    owner    => "shibd",
    group    => "shibd",
    mode     => '0600',
    source   => "${keystone_unipd_cert}",
    tag      => ["shibboleth_sec"],
  }

  file { "/etc/shibboleth/attribute-map.xml":
    ensure   => file,
    owner    => "root",
    group    => "root",
    mode     => '0644',
    source   => "puppet:///modules/controller_rocky/attribute-map.xml",
    tag      => ["shibboleth_conf"],
  }

  file { "/etc/shibboleth/idem-template-metadata.xml":
    ensure   => file,
    owner    => "root",
    group    => "root",
    mode     => '0644',
    content  => template("controller_rocky/idem-template-metadata.xml.erb"),
    tag      => ["shibboleth_conf"],
  }

  file { "/etc/shibboleth/shibboleth2.xml":
    ensure   => file,
    owner    => "root",
    group    => "root",
    mode     => '0644',
    content  => template("controller_rocky/shibboleth2.xml.erb"),
    tag      => ["shibboleth_conf"],
  }

  service { "shibd":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
  }
  
  Package["shibboleth"] -> File <| tag == 'shibboleth_sec' |> ~> Service["shibd"]
  Package["shibboleth"] -> File <| tag == 'shibboleth_conf' |> ~> Service["shibd"]

}
