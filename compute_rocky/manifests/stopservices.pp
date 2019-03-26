class compute_rocky::stopservices inherits compute_rocky::params {
#include compute_rocky::params

# Services needed
#systemctl stop openvswitch
#systemctl stop neutron-openvswitch-agent
#systemctl stop openstack-nova-compute
###

       service { "stop openvswitch service":
                        stop        => "/usr/bin/systemctl stop openvswitch"
                        #require     => Package["openstack-neutron-openvswitch"],
               }

       service { 'stop neutron-openvswitch-agent service':
                        stop        => "/usr/bin/systemctl stop neutron-openvswitch-agent"
                        #require     => Package["openstack-neutron-openvswitch"],
               }

       service { 'stop openstack-nova-compute service':
                        stop        => "/usr/bin/systemctl stop openstack-nova-compute"
                        #require     => Package["openstack-nova-compute"],
               }
}
