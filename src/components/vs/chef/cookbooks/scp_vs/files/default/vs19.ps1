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
$vsProc.ExitCode

# resharper
$rFile = ".\resharper.exe"
$rUrl = "https://download-cf.jetbrains.com/resharper/ReSharperUltimate.2019.2.2/JetBrains.ReSharper.2019.2.2.web.exe"
Start-BitsTransfer -Source $rUrl -Destination $rFile

$rArgs = @(
    "/SpecificProductNames=ReSharper"
    "/Silent=True"
    "/VsVersion=16.0"
)

$rProc = Start-Process $rFile -ArgumentList $rArgs -wait -NoNewWindow -PassThru -RedirectStandardOutput 'resharper-output.txt'
$rProc.ExitCode
