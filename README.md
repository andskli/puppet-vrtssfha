vrtssfha
========

***OMG WTF BBQ!!*** This repo is left as a stub, as I'm unable to continue my
work on this module without and active RHEL subscription. The VxFS kernel
module seems to have issues on CentOS6.5.

This is module is supposed to handle VRTS Storage Foundation.

Requires that RPM packages from SFHA DVD provided by Symantec is in a accessible yum repository, follow instructions at [this link](https://sort.symantec.com/public/documents/sfha/6.0/linux/productguides/html/sf_install/ch08s03.htm)


Example manifest:

	yumrepo { 'VRTSrepo':
		descr           => 'Local VRTSrepo',
		baseurl         => 'file:///files/VRTSrepo',
  		gpgcheck        => 0,
	}

	class { 'vrtssfha::install':
		license			=> 'keyless',
		pkgset			=> 'all',
	}


License
-------


Contact
-------


Support
-------

Please log tickets and issues at our [Projects site](http://projects.example.com)
