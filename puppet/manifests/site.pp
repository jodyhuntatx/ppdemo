node default {

}

node /^dev-webapp.*$/ {
    #Sample node with hardcode secret

    $mysecretkey  = Sensitive('H@rdC0de$e(e1')
    $mydbpassword  = Sensitive('puff, the magic dragon')

    notify { "*** Secret key - encrypted:  ${mysecretkey} ": }
    notify { "*** Secret key - unencrypted:  ${mysecretkey.unwrap} ": }
    notify { "*** DB Password - encrypted:  ${mydbpassword} ": }
    notify { "*** DB Password - unencrypted:  ${mydbpassword.unwrap} ": }
    notify { "******* Writing secret key to file /etc/mysecretkey ******": }
    file { '/etc/mysecretkey':
      ensure => file,
      content => $mysecretkey,
    }
}


node /^prod-webapp.*$/ {

    #Sample node with secret store in conjur

    class { conjur:
      appliance_url      => 'https://conjur/api',
      authn_login        => "host/${::trusted['hostname']}",
      host_factory_token => Sensitive('3pjjmwn3xtaap430ctvhk2yr6b85es43733pgvjkt25g3ah61abn7yn'),
      ssl_certificate    => file('/etc/conjur.pem'),
      version            => 5,
    }

    $mysecretkey = conjur::secret('puppetdemo/secretkey')
    $mydbpassword = conjur::secret('puppetdemo/dbpassword')


    notify { "*** Secret key - encrypted:  ${mysecretkey} ": }
    notify { "*** Secret key - unencrypted:  ${mysecretkey.unwrap} ": }
    notify { "*** DB Password - encrypted:  ${mydbpassword} ": }
    notify { "*** DB Password - unencrypted:  ${mydbpassword.unwrap} ": }
    notify { "******* Writing secret key to file /etc/mysecretkey ******": }
    file { '/etc/mysecretkey':
      ensure => file,
      content => Sensitive($mysecretkey),
      mode => '0600'
    }

}
