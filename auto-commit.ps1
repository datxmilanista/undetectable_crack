# Script chạy tự động tất cả
Write-Host "🚀 Bắt đầu tạo commits tự động..." -ForegroundColor Magenta

# Kiểm tra xem có Git không
$gitPath = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitPath) {
    Write-Host "❌ Lỗi: Git không được tìm thấy!" -ForegroundColor Red
    Write-Host "Vui lòng cài đặt Git từ: https://git-scm.com/download/win" -ForegroundColor Yellow
    Read-Host "Nhấn Enter để thoát"
    exit 1
}

Write-Host "✅ Git được tìm thấy tại: $($gitPath.Source)" -ForegroundColor Green

# Kiểm tra git repository
if (-not (Test-Path ".git")) {
    Write-Host "❌ Không phải git repository!" -ForegroundColor Red
    Read-Host "Nhấn Enter để thoát"
    exit 1
}

Write-Host "✅ Đang ở trong git repository" -ForegroundColor Green

# Hiển thị menu
Write-Host "`n📋 Chọn loại commit muốn tạo:" -ForegroundColor Cyan
Write-Host "1. Tạo commit nhanh (5-10 commits ngay lập tức)"
Write-Host "2. Tạo commit với lịch sử (commits trong nhiều ngày qua)"
Write-Host "3. Tùy chỉnh số lượng commit"
Write-Host "4. Thoát"

$choice = Read-Host "`nNhập lựa chọn (1-4)"

switch ($choice) {
    "1" {
        Write-Host "`n🔥 Tạo commit nhanh..." -ForegroundColor Yellow
        .\quick-commit.ps1 -count 7
        
        $pushChoice = Read-Host "`nBạn có muốn push lên GitHub ngay không? (y/n)"
        if ($pushChoice -eq "y" -or $pushChoice -eq "Y") {
            Write-Host "📤 Đang push lên GitHub..." -ForegroundColor Blue
            git push origin main
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Push thành công!" -ForegroundColor Green
            } else {
                Write-Host "❌ Lỗi khi push!" -ForegroundColor Red
            }
        }
    }
    
    "2" {
        Write-Host "`n📅 Tạo commit với lịch sử..." -ForegroundColor Yellow
        $days = Read-Host "Nhập số ngày (mặc định 14)"
        if ([string]::IsNullOrEmpty($days)) { $days = 14 }
        
        $commitsPerDay = Read-Host "Nhập số commit mỗi ngày (mặc định 2)"
        if ([string]::IsNullOrEmpty($commitsPerDay)) { $commitsPerDay = 2 }
        
        .\create-fake-commits.ps1 -days $days -commitsPerDay $commitsPerDay
        
        $pushChoice = Read-Host "`nBạn có muốn push lên GitHub ngay không? (y/n)"
        if ($pushChoice -eq "y" -or $pushChoice -eq "Y") {
            Write-Host "📤 Đang push lên GitHub..." -ForegroundColor Blue
            git push origin main
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Push thành công!" -ForegroundColor Green
            } else {
                Write-Host "❌ Lỗi khi push!" -ForegroundColor Red
            }
        }
    }
    
    "3" {
        Write-Host "`n⚙️ Tùy chỉnh commit..." -ForegroundColor Yellow
        $count = Read-Host "Nhập số lượng commit muốn tạo"
        if ([string]::IsNullOrEmpty($count)) { $count = 5 }
        
        .\quick-commit.ps1 -count $count
        
        $pushChoice = Read-Host "`nBạn có muốn push lên GitHub ngay không? (y/n)"
        if ($pushChoice -eq "y" -or $pushChoice -eq "Y") {
            Write-Host "📤 Đang push lên GitHub..." -ForegroundColor Blue
            git push origin main
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Push thành công!" -ForegroundColor Green
            } else {
                Write-Host "❌ Lỗi khi push!" -ForegroundColor Red
            }
        }
    }
    
    "4" {
        Write-Host "👋 Tạm biệt!" -ForegroundColor Cyan
        exit 0
    }
    
    default {
        Write-Host "❌ Lựa chọn không hợp lệ!" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Hoàn thành! Kiểm tra GitHub để xem kết quả." -ForegroundColor Green
Read-Host "Nhấn Enter để thoát"
