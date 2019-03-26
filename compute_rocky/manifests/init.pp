class compute_rocky ($cloud_role_foreman = "undefined") { 

  $cloud_role = $cloud_role_foreman  

  # system check setting (network, selinux, CA files)
    class {'compute_rocky::systemsetting':}

  # stop services 
    class {'compute_rocky::stopservices':}

  # install
    class {'compute_rocky::install':}

  # setup firewall
    class {'compute_rocky::firewall':}

  # setup bacula
    class {'compute_rocky::bacula':}
  
  # setup libvirt
    class {'compute_rocky::libvirt':}

  # setup ceph
    class {'compute_rocky::ceph':}

  # setup rsyslog
    class {'compute_rocky::rsyslog':}

  # service
    class {'compute_rocky::service':}

  # install and configure nova
     class {'compute_rocky::nova':}

  # install and configure neutron
     class {'compute_rocky::neutron':}

  # nagios settings
     class {'compute_rocky::nagiossetting':}

  # do passwdless access
      class {'compute_rocky::pwl_access':}


# execution order
             Class['compute_rocky::firewall'] -> Class['compute_rocky::systemsetting']
             Class['compute_rocky::systemsetting'] -> Class['compute_rocky::stopservices']
             Class['compute_rocky::stopservices'] -> Class['compute_rocky::install']
             #Class['compute_rocky::systemsetting'] -> Class['compute_rocky::install']
             Class['compute_rocky::install'] -> Class['compute_rocky::bacula']
             Class['compute_rocky::bacula'] -> Class['compute_rocky::nova']
             Class['compute_rocky::nova'] -> Class['compute_rocky::libvirt']
             Class['compute_rocky::libvirt'] -> Class['compute_rocky::neutron']
             Class['compute_rocky::neutron'] -> Class['compute_rocky::ceph']
             Class['compute_rocky::neutron'] -> Class['compute_rocky::nagiossetting']
             Class['compute_rocky::neutron'] -> Class['compute_rocky::pwl_access']
################           
}
  
