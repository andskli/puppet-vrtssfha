class vrtssfha::install (
  $license          = 'keyless',
  $pkgset           = 'min',
) {

  $sf_minpkgs = ['VRTSperl', 'VRTSvlic', 'VRTSvxvm', 'VRTSaslapm', 'VRTSvxfs',
                  'VRTSfsadv', 'VRTSsfcpi61']
  $sf_recpkgs = ['VRTSperl', 'VRTSvlic', 'VRTSspt', 'VRTSvxvm', 'VRTSaslapm',
                  'VRTSob', 'VRTSvxfs', 'VRTSfsadv', 'VRTSdbed', 'VRTSodm',
                  'VRTSsfmh', 'VRTSsfcpi61']
  $sf_allpkgs = ['VRTSperl', 'VRTSvlic', 'VRTSspt', 'VRTSvxvm', 'VRTSaslapm',
                  'VRTSob', 'VRTSlvmconv', 'VRTSvxfs', 'VRTSfsadv',
                  'VRTSfssdk', 'VRTSdbed', 'VRTSodm', 'VRTSsfmh',
                  'VRTSsfcpi61']

  $sf_pkgs = $pkgset ? {
    default       => $sf_minpkgs,
    'min'         => $sf_minpkgs,
    'rec'         => $sf_recpkgs,
    'all'         => $sf_allpkgs,
  }

  package { $sf_pkgs:
    ensure        => installed,
    provider      => yum,
  }

  $license_cmd = $license ? {
    default => '/opt/VRTS/bin/vxkeyless -q set APPLICATIONHA,DMP,SFBASIC,SFCFSHAENT,SFCFSHAENT_GCO,SFCFSHAENT_VFR,SFCFSHAENT_VFR_GCO,SFCFSHAENT_VR,SFCFSHAENT_VR_GCO,SFENT,SFENT_VFR,SFENT_VR,SFHAENT,SFHAENT_GCO,SFHAENT_VFR,SFHAENT_VFR_GCO,SFHAENT_VR,SFHAENT_VR_GCO,SFHASTD,SFHASTD_VFR,SFHASTD_VR,SFRACENT,SFRACENT_GCO,SFRACENT_VFR,SFRACENT_VFR_GCO,SFRACENT_VR,SFRACENT_VR_GCO,SFSTD,SFSTD_VFR,SFSTD_VR,SFSYBASECE,SFSYBASECE_GCO,SFSYBASECE_VFR,SFSYBASECE_VFR_GCO,SFSYBASECE_VR,SFSYBASECE_VR_GCO,VCS,VCS_GCO',
    'keyless' => '/opt/VRTS/bin/vxkeyless -q set APPLICATIONHA,DMP,SFBASIC,SFCFSHAENT,SFCFSHAENT_GCO,SFCFSHAENT_VFR,SFCFSHAENT_VFR_GCO,SFCFSHAENT_VR,SFCFSHAENT_VR_GCO,SFENT,SFENT_VFR,SFENT_VR,SFHAENT,SFHAENT_GCO,SFHAENT_VFR,SFHAENT_VFR_GCO,SFHAENT_VR,SFHAENT_VR_GCO,SFHASTD,SFHASTD_VFR,SFHASTD_VR,SFRACENT,SFRACENT_GCO,SFRACENT_VFR,SFRACENT_VFR_GCO,SFRACENT_VR,SFRACENT_VR_GCO,SFSTD,SFSTD_VFR,SFSTD_VR,SFSYBASECE,SFSYBASECE_GCO,SFSYBASECE_VFR,SFSYBASECE_VFR_GCO,SFSYBASECE_VR,SFSYBASECE_VR_GCO,VCS,VCS_GCO',
  }

  exec { 'fix_licensing':
    command       => $license_cmd,
    require       => Package['VRTSvlic'],
    before        => Exec['vxdctl_init'],
  }

  exec { 'vxdctl_init':
    path          => '/bin:/usr/bin:/usr/sbin:/sbin',
    command       => 'vxdctl init',
    require       => [Package['VRTSvxvm'], Exec['fix_licensing'], Exec['restart_vxconfigd']],
    onlyif        => 'test ! -f /etc/vx/volboot',
    notify        => Exec['vxdctl_enable'],
  }

  exec { 'vxdctl_enable':
    path          => '/bin:/usr/bin:/usr/sbin:/sbin',
    command       => 'vxdctl enable',
    require       => Package['VRTSvxvm'],
    onlyif        => 'test -f /etc/vx/volboot',
  }

  exec { 'restart_vxconfigd':
    path          => '/usr/bin:/bin:/usr/sbin:/sbin',
    command       => 'vxconfigd -k',
    unless        => 'pgrep vxconfigd',
    returns       => [0, 2],
  }

}
