param(
    $vsPath
)

# vs
$vsArgs = @(
    "--wait"
    "--passive"
    "--norestart"
    "--add"
    "Microsoft.VisualStudio.Component.Web"
    "--add"
    "Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools"
    "--includeRecommended"
)

$vsProc = Start-Process $vsPath -ArgumentList $vsArgs -wait -NoNewWindow -PassThru -RedirectStandardOutput 'vs19p-output.txt'
$vsProc
