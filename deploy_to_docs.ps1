# Deploy Flutter Web to docs folder for GitHub Pages

Write-Host "Building Flutter web app..." -ForegroundColor Cyan
flutter build web --release --base-href "/sound-gen/"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Cleaning docs folder..." -ForegroundColor Cyan
if (Test-Path "docs") {
    Remove-Item -Path "docs" -Recurse -Force
}

Write-Host "Copying build to docs folder..." -ForegroundColor Cyan
Copy-Item -Path "build\web" -Destination "docs" -Recurse

Write-Host "Deployment complete! Ready to commit and push." -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  git add docs" -ForegroundColor White
Write-Host "  git commit -m 'Deploy to GitHub Pages'" -ForegroundColor White
Write-Host "  git push" -ForegroundColor White
