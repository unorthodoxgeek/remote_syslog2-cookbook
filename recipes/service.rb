node['remote_syslog2']['config'].to_a.each_with_index do |index, conf|
  suffix = index > 0 ? "_#{index}" : ""

  template "/etc/init.d/remote_syslog2#{suffix}" do
    source 'remote_syslog2.erb'
    mode '0755'
    variables({suffix: suffix})
    notifies :restart, "service[remote_syslog2#{suffix}]", :delayed
  end

  service "remote_syslog2#{suffix}" do
    supports restart: true, status: true
    action [:start, :enable]
  end
end


