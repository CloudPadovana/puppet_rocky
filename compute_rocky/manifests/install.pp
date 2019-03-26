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
                ]

  $newrelease =  'centos-release-openstack-rocky'

  $genericpackages = [   "openstack-utils",
                         "yum-plugin-priorities",
                         "ipset",
                         "sysfsutils", ]

  $neutronpackages = [   "openstack-neutron",
                         "openstack-neutron-openvswitch",
                         "openstack-neutron-common",
                         "openstack-neutron-ml2", ]

  $novapackages = [ "openstack-nova-compute",
                     "openstack-nova-common", ]


  exec { "removepackage_zeromq":
         command => "/usr/bin/yum -y erase zeromq",
         onlyif => "/bin/rpm -qa | grep centos-release-openstack-ocata",
  } ->

  
  removepackage{
     $oldrelease :
  } ->


  package { $newrelease :
    ensure => 'installed',
  } ->


  exec { "yum update":
         command => "/usr/bin/yum -y update",
         onlyif => "/bin/rpm -qi zeromq | grep 'not installed'",
  } ->

## Rename nova config file  
  exec { "mv_nova_conf_old":
         command => "/usr/bin/mv /etc/nova/nova.conf /etc/nova/nova.conf.ocata",
         onlyif  => "/usr/bin/test -e /etc/nova/nova.conf.rpmnew",
  } ->
 
  exec { "mv_nova_conf_new":
         command => "/usr/bin/mv /etc/nova/nova.conf.rpmnew /etc/nova/nova.conf",
         onlyif  => "/usr/bin/test -e /etc/nova/nova.conf.rpmnew",
  } ->

## Install generic packages
  package { $genericpackages: 
    ensure => "installed",
    require => Package[$newrelease]
   } ->

  package { $neutronpackages: 
    ensure => "installed",
    require => Package[$newrelease]
  } ->

  package { $novapackages: 
    ensure => "installed",
    require => Package[$newrelease]
  } ->
  
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
