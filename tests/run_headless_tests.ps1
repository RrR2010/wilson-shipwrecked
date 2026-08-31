param(
    [string]$Godot = "godot"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$headlessDir = Join-Path $PSScriptRoot "headless"
$tests = Get-ChildItem -Path $headlessDir -Filter "*_test.gd" -File | Sort-Object Name

if ($tests.Count -eq 0) {
    Write-Error "No headless tests found in $headlessDir"
    exit 1
}

$failed = @()

foreach ($test in $tests) {
    $testName = [System.IO.Path]::GetFileNameWithoutExtension($test.Name)
    $relativeScript = "tests/headless/$($test.Name)"

    Write-Host "=== $testName ==="

    $outputLines = @(
        & $Godot --headless --path $repoRoot --script $relativeScript 2>&1 |
            ForEach-Object { $_.ToString() }
    )
    $exitCode = $LASTEXITCODE
    $output = $outputLines -join "`n"

    foreach ($line in $outputLines) {
        Write-Host $line
    }

    $reasons = @()

    if ($exitCode -ne 0) {
        $reasons += "Godot exit code was $exitCode"
    }

    if ($output -match '(?m)^\s*SCRIPT ERROR:') {
        $reasons += "SCRIPT ERROR detected"
    }

    if ($output -match '(?m)^\s*ERROR:') {
        $reasons += "Godot ERROR detected"
    }

    if ($output -match '(?m)^\s*(Parse|Compile) Error:') {
        $reasons += "parse/compile error detected"
    }

    if ($output -match '(?m)^FAIL\s+') {
        $reasons += "test emitted FAIL"
    }

    $expectedPass = "PASS $testName"
    $passCount = ([regex]::Matches($output, "(?m)^$([regex]::Escape($expectedPass))$")).Count
    if ($passCount -ne 1) {
        $reasons += "expected exactly one '$expectedPass', found $passCount"
    }

    if ($reasons.Count -gt 0) {
        $failed += [PSCustomObject]@{
            Test = $testName
            Reasons = ($reasons -join "; ")
        }
        Write-Host "RUNNER FAIL $testName :: $($reasons -join '; ')"
    } else {
        Write-Host "RUNNER PASS $testName"
    }

    Write-Host ""
}

if ($failed.Count -gt 0) {
    Write-Host "Headless suite failed: $($failed.Count)/$($tests.Count) test(s)"
    foreach ($failure in $failed) {
        Write-Host " - $($failure.Test): $($failure.Reasons)"
    }
    exit 1
}

Write-Host "PASS headless_suite ($($tests.Count) tests)"
exit 0
