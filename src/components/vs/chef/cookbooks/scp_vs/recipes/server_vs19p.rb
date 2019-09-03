scp_vs_server '' do
  server_options node['scp_vs']['vs19p']
  action :install
end
