define controller_rocky::oidc_provider($fqdn, $url, $iss, $enc_iss, $client_id, $secret, $descr) {

  exec { "download_metadata_${title}":
    command => '/usr/bin/wget -q -O /var/cache/httpd/mod_auth_openidc/metadata/${fqdn}.provider ${url}',
    creates => "/var/cache/httpd/mod_auth_openidc/metadata/${fqdn}.provider",
    require => File["/var/cache/httpd/mod_auth_openidc/metadata"],
    tag     => ["oidc_conf"],
  }

  file { "${fqdn}.client":
    ensure   => file,
    owner    => "apache",
    group    => "apache",
    mode     => '0640',
    content  => '{"client_id" : "${client_id}", "client_secret" : "${secret}"}\n',
    tag      => ["oidc_conf"],
  }

  file { "${fqdn}.conf":
    ensure   => file,
    owner    => "apache",
    group    => "apache",
    mode     => '0640',
    content  => '{"scope" : "openid profile email", "token_endpoint_auth" : "client_secret_basic", "response_type" : "code"}\n',
    tag      => ["oidc_conf"],
  }

}
