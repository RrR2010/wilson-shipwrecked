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

$results = @()
$engineBanner = $null

foreach ($test in $tests) {
    $testName = [System.IO.Path]::GetFileNameWithoutExtension($test.Name)
    $relativeScript = "tests/headless/$($test.Name)"

    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $outputLines = @(
        & $Godot --headless --path $repoRoot --script $relativeScript 2>&1 |
            ForEach-Object { $_.ToString() }
    )
    $exitCode = $LASTEXITCODE
    $ErrorActionPreference = $previousPreference

    if (-not $engineBanner) {
        $engineBanner = $outputLines | Where-Object { $_ -match '^Godot Engine ' } | Select-Object -First 1
        if ($engineBanner) {
            Write-Host $engineBanner
            Write-Host ""
        }
    }

    $output = $outputLines -join "`n"
    $hasScriptError = $output -match '(?m)^\s*SCRIPT ERROR:'
    $hasGodotError = $output -match '(?m)^\s*ERROR:'
    $hasParseCompileError = $output -match '(?m)^\s*(Parse|Compile) Error:'
    $hasExplicitFail = $output -match '(?m)^FAIL\s+'

    $expectedPass = "PASS $testName"
    $passCount = ([regex]::Matches($output, "(?m)^$([regex]::Escape($expectedPass))$")).Count

    $reasons = @()
    if ($exitCode -ne 0) { $reasons += "exit=$exitCode" }
    if ($hasScriptError) { $reasons += "SCRIPT ERROR" }
    if ($hasParseCompileError) { $reasons += "parse/compile error" }
    if ($hasGodotError) { $reasons += "Godot ERROR" }
    if ($hasExplicitFail) { $reasons += "explicit FAIL" }
    if ($passCount -ne 1) { $reasons += "PASS marker count=$passCount" }

    $status = "PASS"
    if ($hasExplicitFail) {
        $status = "FAIL"
    } elseif ($reasons.Count -gt 0) {
        $status = "ERROR"
    }

    $results += [PSCustomObject]@{
        Test = $testName
        Status = $status
        Reasons = ($reasons -join "; ")
    }

    if ($status -eq "PASS") {
        Write-Host "RUNNER $testName`: PASS"
        continue
    }

    $suffix = if ($reasons.Count -gt 0) { " ($($reasons -join '; '))" } else { "" }
    Write-Host "RUNNER $testName`: $status$suffix"

    $diagnostics = $outputLines | Where-Object {
        $_ -notmatch '^Godot Engine ' -and
        $_ -notmatch '^\s*$' -and
        $_ -notmatch "^PASS\s+$([regex]::Escape($testName))$" -and
        ($_ -match '^\s*(SCRIPT ERROR:|ERROR:|Parse Error:|Compile Error:|FAIL\s+)')
    }
    foreach ($line in $diagnostics) {
        Write-Host $line
    }
}

$passed = @($results | Where-Object { $_.Status -eq "PASS" }).Count
$failed = @($results | Where-Object { $_.Status -eq "FAIL" }).Count
$errors = @($results | Where-Object { $_.Status -eq "ERROR" }).Count
$total = $results.Count

Write-Host ""
Write-Host "RESULT: $passed PASS / $total TOTAL"
if ($failed -gt 0 -or $errors -gt 0) {
    Write-Host "        $failed FAIL / $errors ERROR"
    exit 1
}

Write-Host "PASS headless_suite ($total tests)"
exit 0
