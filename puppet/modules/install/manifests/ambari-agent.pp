class install::ambari-agent {

  exec{"ambari-repo":
    command => "wget -O /etc/yum.repos.d/ambari.repo http://dev.hortonworks.com.s3.amazonaws.com/ambari/centos6/1.x/updates/1.6.1/ambari.repo",
    require => Package["wget"],
    unless => "ls -al /etc/yum.repos.d/ambari.repo"
  }


  package {"ambari-agent":
    ensure => installed,
    require => Exec["ambari-repo"]
  }

  exec {"register ambari agent":
    command => 'sed -i.bak "/^hostname/ s/.*/hostname=ambari.hortonworks.com/" /etc/ambari-agent/conf/ambari-agent.ini',
    require => Package["ambari-agent"]
  }

  exec {"ambari-agent start":
    command => "ambari-agent start",
    require => Exec["register ambari agent"]
  }

}