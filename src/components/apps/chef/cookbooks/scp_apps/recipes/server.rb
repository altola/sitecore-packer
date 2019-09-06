scp_apps_server '' do
  server_options node['scp_apps']['server']
  action :install
end
