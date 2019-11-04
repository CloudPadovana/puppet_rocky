class compute_rocky::collectd inherits compute_rocky::params {

    $collectdpackages= [ 'collectd', 'collectd-virt' ]
  
    package { $collectdpackages :
                       ensure => 'installed',
                   }
                   

   file { "/etc/collectd.conf":
         ensure   => file,
         owner    => "root",
         group    => "root",
         mode     => '0644',
         content  => template("compute_rocky/collectd.conf.erb"),
         require => Package[$collectdpackages],
       }

   service { "collectd":
                             ensure      => running,
                             enable      => true,
                             hasstatus   => true,
                             hasrestart  => true,
                             require     => Package[$collectdpackages],
                             subscribe   => File['/etc/collectd.conf'],
                    }
                    
       
  }
