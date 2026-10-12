# Read-only inspection of Git state and local 3D files; no clean/reset/commit/push.
# Run from any repository worktree: powershell -File .\tools\audit_local_work.ps1
[CmdletBinding()]
param(
    [string]$Path = ".",
    [int]$TopAssets = 80
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = (& git -C $Path rev-parse --show-toplevel 2>$null)
if ($LASTEXITCODE -ne 0 -or -not $root) { throw "Path is not a Git worktree: $Path" }

# Preserve all worktrees; identify local changes, remote tracking, and recent commits.
Write-Host "=== Repository: $root ==="
Write-Host "=== All worktrees ==="
& git -C $root worktree list --porcelain
Write-Host "=== Tracking branches ==="
& git -C $root branch -vv
Write-Host "=== Current status (including untracked) ==="
& git -C $root status --short --branch --untracked-files=all
Write-Host "=== Current branch commits absent from origin/main (may include squash-equivalent commits) ==="
& git -C $root log --oneline --decorate "origin/main..HEAD"
Write-Host "=== Untracked files (including ignored exclusions by Git defaults) ==="
& git -C $root ls-files --others --exclude-standard

# A local asset may be ignored or generated; inventory physical candidates as well.
Write-Host "=== Recently modified 3D source/export/reference files ==="
$extensions = @(".blend", ".blend1", ".blend2", ".glb", ".gltf", ".fbx", ".obj", ".png", ".webp")
Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $extensions -contains $_.Extension.ToLowerInvariant() -and $_.FullName -notmatch '[\\/](\.git|\.godot)[\\/]' } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First $TopAssets FullName, Length, LastWriteTime |
    Format-Table -AutoSize

# Display ignored candidates for diagnosis, but do not recommend adding caches blindly.
Write-Host "=== Ignored 3D candidates (paths only) ==="
& git -C $root ls-files --others --ignored --exclude-standard |
    Where-Object { $_ -match '\.(blend[12]?|glb|gltf|fbx|obj)$' } |
    Select-Object -First $TopAssets

Write-Host "Read-only inspection complete. Run from every separate clone/worktree, and review before git add/commit."
