# Renders cv.html and cv-pl.html to PDF files in cv/ using headless Microsoft Edge.
# Usage (from the repo root):  powershell -ExecutionPolicy Bypass -File tools\build-cv.ps1

$root = Split-Path -Parent $PSScriptRoot
$edge = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edge)) { $edge = "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe" }

$out = Join-Path $root "cv"
New-Item -ItemType Directory -Force $out | Out-Null

$pages = @{
	"cv.html"    = "Oskar-Bielak-CV-EN.pdf"
	"cv-pl.html" = "Oskar-Bielak-CV-PL.pdf"
}

foreach ($page in $pages.Keys) {
	$src = "file:///" + ((Join-Path $root $page) -replace '\\', '/')
	$pdf = Join-Path $out $pages[$page]
	& $edge --headless=new --disable-gpu --no-pdf-header-footer --virtual-time-budget=5000 "--print-to-pdf=$pdf" $src 2>$null | Out-Null
	Write-Host "$page -> cv\$($pages[$page])"
}
