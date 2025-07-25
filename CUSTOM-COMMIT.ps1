# Script tao commit tuy chinh va tu dong xoa
param([int]$count = 10)

$gitPath = ""

# Tim Git
$possiblePaths = @(
    "C:\Program Files\Git\bin\git.exe",
    "C:\Program Files (x86)\Git\bin\git.exe", 
    "C:\Git\bin\git.exe",
    "$env:USERPROFILE\AppData\Local\Programs\Git\bin\git.exe"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $gitPath = $path
        break
    }
}

if (-not $gitPath) {
    Write-Host "LOI: Khong tim thay Git!" -ForegroundColor Red
    exit 1
}

Write-Host "Tao $count commits don gian..." -ForegroundColor Green

# Tao thu muc temp
if (-not (Test-Path "temp")) {
    New-Item -ItemType Directory -Name "temp" | Out-Null
}

$createdFiles = @()

for ($i = 1; $i -le $count; $i++) {
    $fileName = "temp/$i.txt"
    
    # Chi co so thoi
    "$i" | Out-File -FilePath $fileName -Encoding UTF8
    $createdFiles += $fileName
    
    # Add va commit
    & $gitPath add $fileName
    & $gitPath commit -m "Update $i" 
    
    Write-Host "Commit $i/$count" -ForegroundColor Green
    Start-Sleep -Milliseconds 50
}

Write-Host "`nPush len GitHub..." -ForegroundColor Yellow
& $gitPath push origin main

# Xoa file
Write-Host "Xoa file..." -ForegroundColor Yellow
foreach ($file in $createdFiles) {
    Remove-Item $file -Force -ErrorAction SilentlyContinue
}

# Commit xoa file
& $gitPath add -A
& $gitPath commit -m "Clean up"
& $gitPath push origin main

Write-Host "HOAN THANH! $count commits da duoc tao va xoa sach." -ForegroundColor Green
