$ErrorActionPreference = "Stop"

$sourceFile = Join-Path $PSScriptRoot "GuiTestApp.cs"
$outputFile = Join-Path $PSScriptRoot "GuiTestApp.exe"

if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
}

Write-Host "Building GUI Test Playground..."
Add-Type `
    -Path $sourceFile `
    -ReferencedAssemblies "System.Windows.Forms", "System.Drawing", "System.Core" `
    -OutputAssembly $outputFile `
    -OutputType WindowsApplication

Write-Host "Built: $outputFile"
Write-Host "Launching application..."
Start-Process $outputFile
