# Script tao commit don gian va tu dong xoa file
# Noi dung file chi co so, tu dong xoa sau khi push

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

Write-Host "Bat dau tao commit don gian..." -ForegroundColor Green

# Tao thu muc temp
if (-not (Test-Path "temp")) {
    New-Item -ItemType Directory -Name "temp" | Out-Null
}

$commitCount = 5
$createdFiles = @()

for ($i = 1; $i -le $commitCount; $i++) {
    $fileName = "temp/$i.txt"
    
    # Noi dung chi co so thoi
    $content = "$i"
    
    # Tao file
    $content | Out-File -FilePath $fileName -Encoding UTF8
    $createdFiles += $fileName
    
    $messages = @(
        "Update files",
        "Fix issues", 
        "Improve code",
        "Add features",
        "Update docs",
        "Fix bugs",
        "Enhance app", 
        "Update config"
    )
    
    $message = $messages | Get-Random
    
    # Add va commit
    & $gitPath add $fileName
    & $gitPath commit -m "$message"
    
    Write-Host "Commit $i/$commitCount`: $message" -ForegroundColor Green
    Start-Sleep -Milliseconds 100
}

Write-Host "`nDang push len GitHub..." -ForegroundColor Yellow
try {
    & $gitPath push origin main
    Write-Host "THANH CONG: Da push len GitHub!" -ForegroundColor Green
    
    # Tu dong xoa tat ca file da tao
    Write-Host "`nDang xoa cac file da tao..." -ForegroundColor Yellow
    foreach ($file in $createdFiles) {
        if (Test-Path $file) {
            Remove-Item $file -Force
            Write-Host "Da xoa: $file" -ForegroundColor Gray
        }
    }
    
    # Commit viec xoa file
    & $gitPath add -A
    & $gitPath commit -m "Clean up temp files"
    
    Write-Host "`nDang push lan 2 (xoa file)..." -ForegroundColor Yellow
    & $gitPath push origin main
    Write-Host "HOAN THANH! Da xoa tat ca file temp." -ForegroundColor Green
    
} catch {
    Write-Host "LOI: Khong the push!" -ForegroundColor Red
}

Write-Host "`nKet qua:" -ForegroundColor Cyan
Write-Host "- Da tao $commitCount commits" -ForegroundColor White
Write-Host "- Da push len GitHub" -ForegroundColor White  
Write-Host "- Da tu dong xoa tat ca file" -ForegroundColor White
Write-Host "- Repository: https://github.com/datxmilanista/undetectable_crack" -ForegroundColor White

Read-Host "`nNhan Enter de thoat"
