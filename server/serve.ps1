param(
    [int]$Port = 3000
)

# Serve static files from workspace root (one level up from server/)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$siteRoot = Resolve-Path (Join-Path $scriptDir "..")
Write-Host "Serving files from: $siteRoot"

Add-Type -AssemblyName System.Net.HttpListener
$listener = New-Object System.Net.HttpListener
$prefix = "http://+:$Port/"
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
} catch {
    Write-Error "Failed to start listener on $prefix. You may need to run PowerShell as Administrator or add a URL ACL with netsh."
    Write-Host "To allow non-admin binding run (as Administrator):"
    Write-Host "  netsh http add urlacl url=http://+:$Port/ user=Everyone"
    exit 1
}

# Print LAN IPs
$ips = [System.Net.Dns]::GetHostEntry([System.Net.Dns]::GetHostName()).AddressList | Where-Object { $_.AddressFamily -eq 'InterNetwork' -and -not $_.IsIPv6LinkLocal }
if ($ips) {
    Write-Host "Accessible on your LAN at:"
    foreach ($ip in $ips) { Write-Host "  http://$($ip):$Port/" }
}

Write-Host "Listening on $prefix"

function Get-ContentType($ext) {
    switch ($ext.ToLower()) {
        '.html' { 'text/html; charset=utf-8' }
        '.htm' { 'text/html; charset=utf-8' }
        '.css' { 'text/css' }
        '.js' { 'application/javascript' }
        '.json' { 'application/json' }
        '.png' { 'image/png' }
        '.jpg' { 'image/jpeg' }
        '.jpeg' { 'image/jpeg' }
        '.gif' { 'image/gif' }
        default { 'application/octet-stream' }
    }
}

while ($listener.IsListening) {
    $context = $listener.GetContext()
    Start-Job -ArgumentList $context, $siteRoot -ScriptBlock {
        param($context, $siteRoot)
        $req = $context.Request
        $res = $context.Response
        $urlPath = [System.Uri]::UnescapeDataString($req.Url.AbsolutePath)
        if ($urlPath -eq '/' -or $urlPath -eq '') { $urlPath = '/home.html' }
        $filePath = Join-Path $siteRoot.TrimEnd('\') ($urlPath.TrimStart('/'))
        if (Test-Path $filePath) {
            try {
                $bytes = [System.IO.File]::ReadAllBytes($filePath)
                $res.ContentType = (Get-ContentType ([System.IO.Path]::GetExtension($filePath)))
                $res.ContentLength64 = $bytes.Length
                $res.OutputStream.Write($bytes, 0, $bytes.Length)
            } catch {
                $res.StatusCode = 500
                $msg = "Internal server error"
                $buf = [System.Text.Encoding]::UTF8.GetBytes($msg)
                $res.OutputStream.Write($buf, 0, $buf.Length)
            }
        } else {
            $res.StatusCode = 404
            $msg = "404 - Not Found"
            $buf = [System.Text.Encoding]::UTF8.GetBytes($msg)
            $res.OutputStream.Write($buf, 0, $buf.Length)
        }
        $res.OutputStream.Close()
    } | Out-Null
}

$listener.Stop()
$listener.Close()
