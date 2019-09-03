property :server_options, Hash, required: true

default_action :install

action :prepare do
end

action :install do
  directory_path = "#{Chef::Config[:file_cache_path]}/scp_vs/server"

  directory directory_path do
    recursive true
    action :create
  end

  script_file_name = 'vs19.ps1'
  script_file_path = "#{directory_path}/#{script_file_name}"
  cookbook_file script_file_path do
    source script_file_name
    cookbook 'scp_vs'
    action :create
  end

  exe_file_name = 'vs_professional.exe'
  exe_file_path = "#{directory_path}/#{exe_file_name}"
  cookbook_file exe_file_path do
    source exe_file_name
    cookbook 'scp_vs'
    action :create
  end

  # Run installation
  scp_windows_powershell_script_elevated 'Run installation' do
    code "& '#{script_file_path}'"
    cwd 'c:/tmp'
    action :run
  end
end
