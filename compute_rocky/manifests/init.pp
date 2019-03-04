class compute_rocky ($cloud_role_foreman = "undefined") { 

  $cloud_role = $cloud_role_foreman  

  # system check setting (network, selinux, CA files)
    class {'compute_rocky::systemsetting':}

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

  # do configuration
  #  class {'compute_rocky::configure':}

  # service
    class {'compute_rocky::service':}

  # install and configure nova
     class {'compute_rocky::nova':}

  # install and configure neutron
     class {'compute_rocky::neutron':}

  # install and configure ceilometer
     class {'compute_rocky::ceilometer':}

  # nagios settings
     class {'compute_rocky::nagiossetting':}

  # do passwdless access
      class {'compute_rocky::pwl_access':}


# Services needed
######################## questi servizi sono stati splittati nel modulo ::service
#      service { "openvswitch":
#                        ensure      => running,
#                        enable      => true,
#                        hasstatus   => true,
#                        hasrestart  => true,
#                        require     => Package["openstack-neutron-openvswitch"],
#                        subscribe   => Class['compute_rocky::configure'],
#              }
              
#       service { "neutron-openvswitch-agent":
#                        ensure      => running,
#                        enable      => true,
#                        hasstatus   => true,
#                        hasrestart  => true,
#                        require     => Package["openstack-neutron-openvswitch"],
#                        subscribe   => Class['compute_rocky::configure'],
#               }

#       service { "neutron-ovs-cleanup":
#                        enable      => true,
#                        require     => Package["openstack-neutron-openvswitch"],
#               }

#       service { "messagebus":
#                     ensure      => running,
#                     enable      => true,
#                     hasstatus   => true,
#                     hasrestart  => true,
#                     require     => Package["libvirt"],
#                }


#       service { "openstack-nova-compute":
#                    ensure      => running,
#                    enable      => true,
#                    hasstatus   => true,
#                    hasrestart  => true,
#                    require     => Package["openstack-nova-compute"],
#                    subscribe   => Class['compute_rocky::configure'],
#               }

#        service { "openstack-ceilometer-compute":
#                    ensure      => running,
#                    enable      => true,
#                    hasstatus   => true,
#                    hasrestart  => true,
#                    require     => Package["openstack-ceilometer-compute"],
#                    subscribe   => Class['compute_rocky::ceilometer'],
#               }

#       exec { 'create_bridge':
#                     command     => "ovs-vsctl add-br br-int",
#                     unless      => "ovs-vsctl br-exists br-int",
#                     require     => Service["openvswitch"],
#            }
########################################                            

           
# execution order
             #Class['compute_rocky::firewall'] -> Class['compute_rocky::install']
             #Class['compute_rocky::install'] -> Class['compute_rocky::configure']
             #Class['compute_rocky::configure'] -> File['/etc/neutron/plugin.ini']
             #Class['compute_rocky::configure'] -> Cron['nagios_check_ovs']
             #Class['compute_rocky::configure'] -> Cron['nagios_check_kvm']
             #Class['compute_rocky::configure'] -> Class['compute_rocky::pwl_access']
             #Service["openvswitch"] -> Exec['create_bridge']
             Class['compute_rocky::firewall'] -> Class['compute_rocky::systemsetting']
             Class['compute_rocky::systemsetting'] -> Class['compute_rocky::install']
             Class['compute_rocky::install'] -> Class['compute_rocky::bacula']
             Class['compute_rocky::bacula'] -> Class['compute_rocky::nova']
             Class['compute_rocky::nova'] -> Class['compute_rocky::libvirt']
             Class['compute_rocky::libvirt'] -> Class['compute_rocky::neutron']
             Class['compute_rocky::neutron'] -> Class['compute_rocky::ceph']
             Class['compute_rocky::neutron'] -> Class['compute_rocky::nagiossetting']
             Class['compute_rocky::neutron'] -> Class['compute_rocky::pwl_access']
             Class['compute_rocky::neutron'] -> Class['compute_rocky::ceilometer']
             Class['compute_rocky::ceilometer'] -> Class['compute_rocky::service']
################           
}
  
