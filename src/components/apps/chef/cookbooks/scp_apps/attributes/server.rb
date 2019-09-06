default['scp_apps']['server'] = {
  'native_packages' => {
    'JetBrains.ReSharper.2019.2.2' => {
      'source' => 'https://download-cf.jetbrains.com/resharper/ReSharperUltimate.2019.2.2/JetBrains.ReSharper.2019.2.2.web.exe',
      'install' => [
        '/SpecificProductNames=ReSharper',
        '/IgnoreExtensions=True',
        '/Silent=True',
        '/VsVersion=16.0'
      ],
      'elevated' => true,
    },
  },
}
