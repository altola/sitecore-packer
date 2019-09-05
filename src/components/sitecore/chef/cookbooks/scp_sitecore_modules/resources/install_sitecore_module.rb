property :options, Hash, required: true
property :secrets, Hash, required: true

default_action :install

action :install do
  config = new_resource.options['config']

  user = new_resource.secrets['user']
  password = new_resource.secrets['password']

  # Pre install script
  script_file_name = 'drop-users-and-set-containment.sql'
  script_file_path = "#{config['root']}/#{script_file_name}"
  template script_file_path do
    source "#{script_file_name}.erb"
    variables('config' => config)
  end

  scp_windows_powershell_script_elevated 'Run pre install script' do
    code "Invoke-Sqlcmd -InputFile '#{script_file_path}' -ServerInstance 'localhost'"
    action :run
  end

  # Download module
  scp_windows_powershell_script_elevated "Download #{config['package_original_name']}" do
    code <<-EOH

      $ProgressPreference='SilentlyContinue';

      if(-not(Test-Path "#{config['package_full_path']}")) {
        $loginRequest = Invoke-RestMethod -Uri https://dev.sitecore.net/api/authorization -Method Post -ContentType "application/json" -Body "{username: '#{user}', password: '#{password}'}" -SessionVariable session -UseBasicParsing
        Invoke-WebRequest -Uri "#{config['package_url']}" -WebSession $session -OutFile "#{config['package_full_path']}" -UseBasicParsing
      }

    EOH
    action :run
    timeout 6000
  end

  # Generate install template
  script_file_name = "install_sitecore_#{config['module']}.ps1"
  script_file_path = "#{config['root']}/#{script_file_name}"
  template script_file_path do
    source 'install_sitecore_module.ps1.erb'
    variables('config' => config)
  end

  # Install module
  scp_windows_powershell_script_elevated "Install #{config['package_original_name']}" do
    code script_file_path
    cwd config['root']
    timeout 6000
    action :run
  end

  # Post install script
  script_file_name = 'add-users-and-set-containment.sql'
  script_file_path = "#{config['root']}/#{script_file_name}"
  template script_file_path do
    source "#{script_file_name}.erb"
    variables('config' => config)
  end

  scp_windows_powershell_script_elevated 'Run post install script' do
    code "Invoke-Sqlcmd -InputFile '#{script_file_path}' -ServerInstance 'localhost'"
    action :run
  end
end
