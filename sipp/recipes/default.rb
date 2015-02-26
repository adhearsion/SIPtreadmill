%w{build-essential openssl libssl-dev libpcap-dev libncurses5-dev}.each { |p| package p }

remote_file '/tmp/sipp-3.3.tar.gz' do
  source "http://downloads.sourceforge.net/project/sipp/sipp/3.3/sipp-3.3.tar.gz"
  checksum "17fd02e6aa71d44a90c65e84a1aa39d3aa329990d4aa48e4fb4b895304dbc920"
end

cookbook_file '/tmp/sipp_dyn_pcap.diff' do
  source 'sipp_dyn_pcap.diff'
end

script "compile sipp" do
  interpreter "/bin/bash"
  cwd "/tmp"
  code <<-EOF
  tar -xf sipp-3.3.tar.gz
  cd sipp-3.3
  patch < ../sipp_dyn_pcap.diff
  make pcapplay
  cp sipp /usr/local/bin
EOF
  not_if do
    system 'sipp'
    $?.exitstatus == 99
  end
end

script "copy pcap files to home directory" do
  interpreter "/bin/bash"
  cwd "/home/vagrant"
  code <<-EOF
  cp -rp /tmp/sipp-3.3/pcap .
  chown -R vagrant:vagrant pcap/
  EOF
end