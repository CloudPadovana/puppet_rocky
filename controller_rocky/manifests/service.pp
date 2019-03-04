class controller_rocky::service inherits controller_rocky::params {
  

  # Ceph
#  class {'controller_rocky::ceph':}
  
  # Configure keystone
#  class {'controller_rocky::configure_keystone':}
  
  # Configure glance
#  class {'controller_rocky::configure_glance':}

  # Configure nova
#  class {'controller_rocky::configure_nova':}

  # Configure horizon
#  class {'controller_rocky::configure_horizon':}

  # Configure ec2
#  class {'controller_rocky::configure_ec2':}

  # Configure neutron
#  class {'controller_rocky::configure_neutron':}

  # Configure cinder
#  class {'controller_rocky::configure_cinder':}

  # Configure heat
#  class {'controller_rocky::configure_heat':}

  # Configure ceilometer
#  class {'controller_rocky::configure_ceilometer':}

  # do passwdless access
#  class {'controller_rocky::pwl_access':}
  
  
  # configure remote syslog
#  class {'controller_rocky::rsyslog':}
  
  
#   file {'INFN-CA.pem':
#                   source      => 'puppet:///modules/controller_rocky/INFN-CA.pem',
#                   path        => '/etc/grid-security/certificates/INFN-CA.pem',
#         }

 ## Services

 service { "memcached":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_horizon'],
           }

 service { "fetch-crl-cron":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
           }

         
 # Services for keystone       
    service { "httpd":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => [ Class['controller_rocky::configure_keystone'], Class['controller_rocky::configure_horizon'], ],
           }

 # Services for Glance
    service { "openstack-glance-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_glance'],
           }
    service { "openstack-glance-registry":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_glance'],
            }

 # Services for nova       
    service { "openstack-nova-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_nova'],
           }
    service { "openstack-nova-consoleauth":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_nova'],
           }
    service { "openstack-nova-scheduler":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_nova'],
           }
    service { "openstack-nova-novncproxy":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_nova'],
           }
    service { "openstack-nova-conductor":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_nova'],
           }
    service { "openstack-nova-cert":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_nova'],
           }
            
 # Services for ec2       
    service { "openstack-ec2-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_ec2'],
           }
    service { "openstack-ec2-api-metadata":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_ec2'],
           }

 # Services for neutron       
    service { "openvswitch":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_neutron'],
           }
    service { "neutron-server":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_neutron'],
           }
    service { "neutron-openvswitch-agent":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_neutron'],
           }
    service { "neutron-dhcp-agent":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_neutron'],
           }
    service { "neutron-metadata-agent":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_neutron'],
           }
    service { "neutron-l3-agent":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_neutron'],
           }

 # Services for cinder
    service { "openstack-cinder-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_cinder'],
           }
    service { "openstack-cinder-scheduler":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_cinder'],
           }
    service { "openstack-cinder-volume":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_cinder'],
           }
    service { "target":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_cinder'],
           }
           
 # Services for heat
    service { "openstack-heat-api":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_heat'],
           }
    service { "openstack-heat-api-cfn":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_heat'],
           }
    service { "openstack-heat-engine":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_heat'],
           }
           
 # Services for ceilometer
    service { "openstack-ceilometer-api":
                   ensure      => stopped,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_ceilometer'],
           }
    service { "openstack-ceilometer-notification":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_ceilometer'],
            }          
    service { "openstack-ceilometer-central":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_ceilometer'],
           }
    service { "openstack-ceilometer-collector":
                   ensure      => running,
                   enable      => true,
                   hasstatus   => true,
                   hasrestart  => true,
                   subscribe   => Class['controller_rocky::configure_ceilometer'],
           }

  }
