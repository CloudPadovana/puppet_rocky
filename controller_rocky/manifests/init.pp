class controller_rocky ($cloud_role_foreman = "undefined") {

  $cloud_role = $cloud_role_foreman

  $ocatapackages = [ "openstack-utils",

                   ]


     package { $ocatapackages: ensure => "installed" }

  # Install CA
  class {'controller_rocky::install_ca_cert':}

  # Ceph
  class {'controller_rocky::ceph':}
  
  # Configure keystone
  class {'controller_rocky::configure_keystone':}
  
  # Configure glance
  class {'controller_rocky::configure_glance':}

  # Configure nova
  class {'controller_rocky::configure_nova':}

  # Configure ec2
  class {'controller_rocky::configure_ec2':}

  # Configure neutron
  class {'controller_rocky::configure_neutron':}

  # Configure cinder
  class {'controller_rocky::configure_cinder':}

  # Configure heat
  class {'controller_rocky::configure_heat':}

#  # Configure ceilometer
#  class {'controller_rocky::configure_ceilometer':}

  # Configure horizon
  class {'controller_rocky::configure_horizon':}

  # Configure Shibboleth if AII and Shibboleth are enabled
  if ($::controller_rocky::params::enable_aai_ext and $::controller_rocky::params::enable_shib)  {
    class {'controller_rocky::configure_shibboleth':}
  }

  # Configure OpenIdc if AII and openidc are enabled
  if ($::controller_rocky::params::enable_aai_ext and $::controller_rocky::params::enable_oidc)  {
    class {'controller_rocky::configure_openidc':}
  }
 
  # Service
  class {'controller_rocky::service':}

  
  # do passwdless access
  class {'controller_rocky::pwl_access':}
  
  
  # configure remote syslog
  class {'controller_rocky::rsyslog':}
  
  

       Class['controller_rocky::install_ca_cert'] -> Class['controller_rocky::configure_keystone']
       Class['controller_rocky::configure_keystone'] -> Class['controller_rocky::configure_glance']
       Class['controller_rocky::configure_glance'] -> Class['controller_rocky::configure_nova']
       Class['controller_rocky::configure_nova'] -> Class['controller_rocky::configure_neutron']
       Class['controller_rocky::configure_neutron'] -> Class['controller_rocky::configure_cinder']
       Class['controller_rocky::configure_cinder'] -> Class['controller_rocky::configure_horizon']
       Class['controller_rocky::configure_horizon'] -> Class['controller_rocky::configure_heat']
       #Class['controller_rocky::configure_heat'] -> Class['controller_rocky::configure_ceilometer']
       #if ($enable_aai_ext and $enable_shib)  {
       #   Class['controller_rocky::configure_ceilometer'] -> Class['controller_rocky::configure_shibboleth']
       #}
       #if ($enable_aai_ext and $enable_oidc) {
       #   Class['controller_rocky::configure_ceilometer'] -> Class['controller_rocky::configure_openidc']
       #}
       #Class['controller_rocky::configure_ceilometer'] -> Class['controller_rocky::service']
            

  }
