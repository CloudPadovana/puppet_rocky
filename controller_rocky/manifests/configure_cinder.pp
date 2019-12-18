class controller_rocky::configure_cinder inherits controller_rocky::params {

#
# Questa classe:
# - popola il file /etc/cinder/cinder.conf
# - popola il file /etc/cinder/policy.yaml
# 
  
define do_config ($conf_file, $section, $param, $value) {
             exec { "${name}":
                              command     => "/usr/bin/openstack-config --set ${conf_file} ${section} ${param} \"${value}\"",
                              require     => Package['openstack-utils'],
                              unless      => "/usr/bin/openstack-config --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                  }
       }

define remove_config ($conf_file, $section, $param, $value) {
             exec { "${name}":
                              command     => "/usr/bin/openstack-config --del ${conf_file} ${section} ${param}",
                              require     => Package['openstack-utils'],
                              onlyif      => "/usr/bin/openstack-config --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"^${value}$\" 2>&1 >/dev/null",
                   }
       }
                                                                                                                                             
  
# cinder.conf
       
   controller_rocky::configure_cinder::do_config { 'cinder_auth_strategy': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'auth_strategy', value => $controller_rocky::params::auth_strategy, }       
   controller_rocky::configure_cinder::do_config { 'cinder_my_ip': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'my_ip', value => $controller_rocky::params::cinder_my_ip, }       
   controller_rocky::configure_cinder::do_config { 'cinder_public_endpoint': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'public_endpoint', value => $controller_rocky::params::cinder_public_endpoint, }
   #MS iscsi_helper deprecated; replaced with target_helper    
   controller_rocky::configure_cinder::do_config { 'cinder_iscsi_helper': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'target_helper', value => $controller_rocky::params::cinder_iscsi_helper, }
   controller_rocky::configure_cinder::do_config { 'cinder_glance_api_servers': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'glance_api_servers', value => $controller_rocky::params::glance_api_servers, }
   controller_rocky::configure_cinder::do_config { 'cinder_enabled_backends': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'enabled_backends', value => $controller_rocky::params::cinder_enabled_backends, }
   controller_rocky::configure_cinder::do_config { 'cinder_default_volume_type': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'default_volume_type', value => $controller_rocky::params::cinder_default_volume_type, }

  ### DEPRECATED in PIKE - removed in QUEENS
  ### In Ocata it was needed otherwise creation of volumes from images doesn't work     
  # controller_rocky::configure_cinder::do_config { 'cinder_glance_api_version': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'glance_api_version', value => $controller_rocky::params::glance_api_version, }


  controller_rocky::configure_cinder::do_config { 'cinder_db': conf_file => '/etc/cinder/cinder.conf', section => 'database', param => 'connection', value => $controller_rocky::params::cinder_db, }
  controller_rocky::configure_cinder::do_config { 'cinder_transport_url': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'transport_url', value => $controller_rocky::params::transport_url, }

   ## FF da queens cambiano le porte, /etc/cinder/cinder.conf [keystone_authtoken] auth_uri = http://controller:5000 e auth_url = http://controller:5000
   ## MS Anche per cinder dovrebbe essere auth_uri --> www_authenticate_uri
   controller_rocky::configure_cinder::do_config { 'cinder_www_authenticate_uri': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'www_authenticate_uri', value => $controller_rocky::params::www_authenticate_uri, }   
   controller_rocky::configure_cinder::do_config { 'cinder_auth_url': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'auth_url', value => $controller_rocky::params::cinder_keystone_authtoken_auth_url, }
   controller_rocky::configure_cinder::do_config { 'cinder_auth_type': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'auth_type', value => $controller_rocky::params::auth_type, }
   controller_rocky::configure_cinder::do_config { 'cinder_project_domain_name': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'project_domain_name', value => $controller_rocky::params::project_domain_name, }
   controller_rocky::configure_cinder::do_config { 'cinder_user_domain_name': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'user_domain_name', value => $controller_rocky::params::user_domain_name, }
   controller_rocky::configure_cinder::do_config { 'cinder_project_name': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'project_name', value => $controller_rocky::params::project_name, }
   controller_rocky::configure_cinder::do_config { 'cinder_username': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'username', value => $controller_rocky::params::cinder_username, }
   controller_rocky::configure_cinder::do_config { 'cinder_password': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'password', value => $controller_rocky::params::cinder_password, }
   controller_rocky::configure_cinder::do_config { 'cinder_cafile': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'cafile', value => $controller_rocky::params::cafile, }
   controller_rocky::configure_cinder::do_config { 'cinder_keystone_authtoken_memcached_servers': conf_file => '/etc/cinder/cinder.conf', section => 'keystone_authtoken', param => 'memcached_servers', value => $controller_rocky::params::memcached_servers, }

   controller_rocky::configure_cinder::do_config { 'cinder_lock_path': conf_file => '/etc/cinder/cinder.conf', section => 'oslo_concurrency', param => 'lock_path', value => $controller_rocky::params::cinder_lock_path, }
##########Iscsi
   controller_rocky::configure_cinder::do_config { 'cinder_iscsi_volume_group': conf_file => '/etc/cinder/cinder.conf', section => 'iscsi-infnpd', param => 'volume_group', value => $controller_rocky::params::iscsi_volume_group, }
   controller_rocky::configure_cinder::do_config { 'cinder_iscsi_volume_backend_name': conf_file => '/etc/cinder/cinder.conf', section => 'iscsi-infnpd', param => 'volume_backend_name', value => $controller_rocky::params::iscsi_volume_backend_name, }
   controller_rocky::configure_cinder::do_config { 'cinder_iscsi_volume_driver': conf_file => '/etc/cinder/cinder.conf', section => 'iscsi-infnpd', param => 'volume_driver', value => $controller_rocky::params::iscsi_volume_driver, }
   controller_rocky::configure_cinder::do_config { 'cinder_iscsi_shares_config': conf_file => '/etc/cinder/cinder.conf', section => 'iscsi-infnpd', param => 'nfs_shares_config', value => $controller_rocky::params::cinder_iscsi_shares_config, }
   controller_rocky::configure_cinder::do_config { 'cinder_iscsi_nfs_mount_point_base': conf_file => '/etc/cinder/cinder.conf', section => 'iscsi-infnpd', param => 'nfs_mount_point_base', value => $controller_rocky::params::cinder_iscsi_nfs_mount_point_base, }
   # The following is needed (at least in Ocata) otherwise there are problems attaching i-scsi volumes to VMs    
   controller_rocky::configure_cinder::do_config { 'cinder_iscsi_nfs_nas_secure_file_permissions': conf_file => '/etc/cinder/cinder.conf', section => 'iscsi-infnpd', param => 'nas_secure_file_permissions', value => $controller_rocky::params::cinder_iscsi_nfs_nas_secure_file_permissions, }


############# Ceph configuration
 controller_rocky::configure_cinder::do_config { 'cinder_ceph_volume_group': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'volume_group', value => $controller_rocky::params::ceph_volume_group, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph_volume_backend_name': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'volume_backend_name', value => $controller_rocky::params::ceph_volume_backend_name, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph_volume_driver': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'volume_driver', value => $controller_rocky::params::ceph_volume_driver, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph_rbd_pool': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_pool', value => $controller_rocky::params::cinder_ceph_rbd_pool, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph_rbd_ceph_conf': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_ceph_conf', value => $controller_rocky::params::ceph_rbd_ceph_conf, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph_rbd_flatten_volume_from_snapshot': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_flatten_volume_from_snapshot', value => $controller_rocky::params::ceph_rbd_flatten_volume_from_snapshot, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph_rbd_store_chunk_size': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_store_chunk_size', value => $controller_rocky::params::ceph_rbd_store_chunk_size, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph_rados_connect_timeout': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rados_connect_timeout', value => $controller_rocky::params::ceph_rados_connect_timeout, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph_rbd_max_clone_depth': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_max_clone_depth', value => $controller_rocky::params::ceph_rbd_max_clone_depth, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph_rbd_user': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_user', value => $controller_rocky::params::cinder_ceph_rbd_user, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph_rbd_secret_uuid': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_secret_uuid', value => $controller_rocky::params::cinder_ceph_rbd_secret_uuid, }
 # MS: Optimization that can be applied since the pool is used only for cinder      
  controller_rocky::configure_cinder::do_config { 'cinder_ceph_rbd_exclusive_cinder_pool': conf_file => '/etc/cinder/cinder.conf', section => 'ceph', param => 'rbd_exclusive_cinder_pool', value => $controller_rocky::params::cinder_ceph_rbd_exclusive_cinder_pool, }

############# Ceph EC configuration
 if $::controller_rocky::cloud_role == "is_test" {

 controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_volume_group': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'volume_group', value => $controller_rocky::params::ceph_ec_volume_group, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_volume_backend_name': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'volume_backend_name', value => $controller_rocky::params::ceph_ec_volume_backend_name, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_volume_driver': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'volume_driver', value => $controller_rocky::params::ceph_volume_driver, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_rbd_pool': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_pool', value => $controller_rocky::params::cinder_ceph_ec_rbd_pool, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_rbd_ceph_conf': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_ceph_conf', value => $controller_rocky::params::ceph_rbd_ceph_ec_conf, }
   controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_rbd_flatten_volume_from_snapshot': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_flatten_volume_from_snapshot', value => $controller_rocky::params::ceph_rbd_flatten_volume_from_snapshot, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_rbd_store_chunk_size': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_store_chunk_size', value => $controller_rocky::params::ceph_rbd_store_chunk_size, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_rados_connect_timeout': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rados_connect_timeout', value => $controller_rocky::params::ceph_rados_connect_timeout, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_rbd_max_clone_depth': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_max_clone_depth', value => $controller_rocky::params::ceph_rbd_max_clone_depth, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_rbd_user': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_user', value => $controller_rocky::params::cinder_ceph_rbd_user, }
  controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_rbd_secret_uuid': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_secret_uuid', value => $controller_rocky::params::cinder_ceph_rbd_secret_uuid, }
 # MS: Optimization that can be applied since the pool is used only for cinder      
  controller_rocky::configure_cinder::do_config { 'cinder_ceph-ec_rbd_exclusive_cinder_pool': conf_file => '/etc/cinder/cinder.conf', section => 'ceph-ec', param => 'rbd_exclusive_cinder_pool', value => $controller_rocky::params::cinder_ceph_rbd_exclusive_cinder_pool, }

}

       
##########EqualLogic
   controller_rocky::configure_cinder::do_config { 'cinder_eqlog_volume_group': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'volume_group', value => $controller_rocky::params::eqlog_volume_group, }
   controller_rocky::configure_cinder::do_config { 'cinder_eqlog_volume_backend_name': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'volume_backend_name', value => $controller_rocky::params::eqlog_volume_backend_name, }
   controller_rocky::configure_cinder::do_config { 'cinder_eqlog_volume_driver': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'volume_driver', value => $controller_rocky::params::eqlog_volume_driver, }
   controller_rocky::configure_cinder::do_config { 'cinder_eqlog_san_ip': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'san_ip', value => $controller_rocky::params::eqlog_san_ip, }
   controller_rocky::configure_cinder::do_config { 'cinder_eqlog_san_login': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'san_login', value => $controller_rocky::params::eqlog_san_login, }
   controller_rocky::configure_cinder::do_config { 'cinder_eqlog_san_password': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'san_password', value => $controller_rocky::params::eqlog_san_password, }
   controller_rocky::configure_cinder::do_config { 'cinder_eqlog_eqlx_group_name': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'eqlx_group_name', value => $controller_rocky::params::eqlog_eqlx_group_name, }
   controller_rocky::configure_cinder::do_config { 'cinder_eqlog_eqlx_pool': conf_file => '/etc/cinder/cinder.conf', section => 'equallogic-unipd', param => 'eqlx_pool', value => $controller_rocky::params::eqlog_eqlx_pool, }

       
#######Proxy headers parsing
controller_rocky::configure_cinder::do_config { 'cinder_enable_proxy_headers_parsing': conf_file => '/etc/cinder/cinder.conf', section => 'oslo_middleware', param => 'enable_proxy_headers_parsing', value => $controller_rocky::params::enable_proxy_headers_parsing, }       
####################       
       
# Settings needed for ceilometer (but we don't use anymore ceilometer)
#   controller_rocky::configure_cinder::do_config { 'cinder_notification_driver': conf_file => '/etc/cinder/cinder.conf', section => 'oslo_messaging_notifications', param => 'driver', value => $controller_rocky::params::cinder_notification_driver, }

#
# Sembra che i seguenti non servano piu`:
##   controller_rocky::configure_cinder::do_config { 'cinder_control_exchange': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'control_exchange', value => $controller_rocky::params::cinder_control_exchange, }
##   controller_rocky::configure_cinder::do_config { 'cinder_glusterfs_sparsed_volumes': conf_file => '/etc/cinder/cinder.conf', section => 'DEFAULT', param => 'glusterfs_sparsed_volumes', value => $controller_rocky::params::cinder_glusterfs_sparsed_volumes, }

#
#       
file {'cinder_policy.yaml':
             source      => 'puppet:///modules/controller_rocky/cinder_policy.yaml',
             path        => '/etc/cinder/policy.yaml',
             backup      => true,
             owner   => root,
             group   => cinder,
             mode    => "0640",
      }
       
}
