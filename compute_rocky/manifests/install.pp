class compute_rocky::install inherits compute_rocky::params {
#include compute_rocky::params

$cloud_role = $compute_rocky::params::cloud_role          

### Repository settings (remove old rpm and install new one)
  
  define removepackage {
    exec {
        "removepackage_$name":
            command => "/usr/bin/yum -y erase $name",
            onlyif => "/bin/rpm -ql $name",
    }
  }

  $oldrelease = [ 'centos-release-openstack-ocata',
                  'centos-release-ceph-jewel',
                  'zeromq',
                ]
  $newrelease = 'centos-release-openstack-rocky'

  removepackage{
     $oldrelease :
  }

  package { $newrelease :
    ensure => 'installed',
  } 

## Install generic packages
  $genericpackages = [   "openstack-utils",
                         "yum-plugin-priorities",
                         "ipset",
                         "sysfsutils" ]
  package { $genericpackages: 
    ensure => "installed",
    require => Package[$newrelease]
   }


#######
  $neutronpackages = [   "openstack-neutron",
                         "openstack-neutron-openvswitch",
                         "openstack-neutron-common",
                         "openstack-neutron-ml2" ]
  package { $neutronpackages: 
    ensure => "installed",
    require => Package[$newrelease]
  }

  $novapackages = [ "openstack-nova-compute",
                     "openstack-nova-common" ]

  package { $novapackages: 
    ensure => "installed",
    require => Package[$newrelease]
  }
  
  $ceilometerpackages = [ "openstack-ceilometer-compute",
                          "python2-wsme" ]
  package { $ceilometerpackages: 
   ensure => "installed",
   require => Package[$newrelease]
  }

          file_line { '/etc/sudoers.d/neutron  syslog':
                path   => '/etc/sudoers.d/neutron',
                line   => 'Defaults:neutron !requiretty, !syslog',
                                match  => 'Defaults:neutron',
                    }
 
if $::compute_rocky::cloud_role == "is_prod_localstorage" or $::compute_rocky::cloud_role ==  "is_prod_sharedstorage" {                             
   package { 'glusterfs-fuse':
              ensure => 'installed',
           }
                                                                                     } 
}
