Vagrant.configure("2") do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.omnibus.chef_version = :latest

  config.vm.define :dev do |dev|
    dev.vm.network :private_network, ip: "10.203.132.10"
    dev.vm.hostname = "dev.local.treadmill.mojolingo.net"

    dev.vm.provider :virtualbox do |vb|
      vb.name = "SIP-Treadmil-Dev"
    end

    dev.vm.synced_folder ".", "/srv/treadmill/current"

    dev.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "apt"
      chef.add_recipe "locale"
      chef.add_recipe "treadmill::database"
      chef.add_recipe "treadmill::app"
      chef.add_recipe "phantomjs"

      chef.log_level = :debug

      chef.json = {
        'locale' => {
          'lang' => "en_US.utf8"
        },
        ruby_build: {
          git_ref: 'v20130806',
        },
        'rvm' => {
          'installs' => { 'vagrant' => true },
          'user_installs' => [
            {
              'user' => 'vagrant',
              'default_ruby'  => '2.2.0',
              'rubies' => ['2.2.0'],
              'install_rubies' => true,
              'gems' => {
                '2.2.0' => [
                  { 'name' => 'bundler' }
                ]
              }
            }
          ]
        },
        "authorization" => {
          "sudo" => {
            "users" => ["vagrant"],
            "passwordless" => "true"
          }
        },
        "postgresql" => {
          "password" => {
            "postgres" => "iloverandompasswordsbutthiswilldo"
          }
        }
      }
    end
  end

  config.vm.define :sink do |sink|
    public_ip = "10.203.132.11"

    sink.vm.network :private_network, ip: public_ip
    sink.vm.hostname = "sink.local.treadmill.mojolingo.net"

    sink.vm.provider :virtualbox do |vb|
      vb.name = "SIP-Treadmil-sink"
    end

    sink.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "apt"
      chef.add_recipe "freeswitch"

      chef.log_level = :debug

      chef.json = {
        freeswitch: {
          tls_only: false,
          local_ip: public_ip,
          dialplan: {
            head_fragments: '<extension name="sink">
  <condition>
    <action application="answer"/>
    <action application="sleep" data="10000"/>
  </condition>
</extension>'
          }
        }
      }
    end
  end

  config.vm.define :deploy do |deploy|
    deploy.vm.box = 'ubuntu/trusty64'

    public_ip = "10.203.132.12"

    deploy.vm.network :private_network, ip: public_ip
    deploy.vm.hostname = "local.treadmill.mojolingo.net"

    deploy.vm.provider :virtualbox do |vb|
      vb.name = "SIP-Treadmil-Deploy"
    end

    deploy.vm.provision "shell", inline: <<-SCRIPT
  wget -qO - https://deb.packager.io/key | sudo apt-key add -
  echo "deb https://deb.packager.io/gh/mojolingo/SIPtreadmill trusty develop" | sudo tee /etc/apt/sources.list.d/SIPtreadmill.list

  sudo apt-get -y update
  sudo apt-get -y install siptreadmill
SCRIPT
  end
end
