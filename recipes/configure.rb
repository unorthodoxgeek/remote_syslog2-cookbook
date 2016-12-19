# Using JSON.parse(x.to_json) to convert Chef::Node::ImmutableArray and
# Chef::Node::ImmutableMash to plain Ruby array and hash.
# https://tickets.opscode.com/browse/CHEF-3953
# Also, convert port to integer since remote_syslog2 does not accept quoted port

config_options = JSON.parse(node['remote_syslog2']['config'].to_json).to_a

config_options.each_with_index do |config, index|
  config['destination']['port'] = config['destination']['port'].to_i
  yaml_config = config.to_yaml
  suffix = index > 0 ? "_#{index}" : ""

  file "#{node['remote_syslog2']['config_file']}#{suffix}" do
    content yaml_config

    mode '0644'
    notifies :restart, "service[remote_syslog2#{suffix}]", :delayed
  end
end