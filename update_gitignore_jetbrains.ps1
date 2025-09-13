# PowerShell script to update .gitignore for JetBrains IDEs across all branches

$branches = @(
    "main",
    "1.0-in-class",
    "1.0-inclass-solution",
    "1.0.0-throwing-exceptions", 
    "1.0.1-throwing-exceptions",
    "1.1.0-using-nullable",
    "1.2.0-using-result",
    "1.2.1-using-result-improve-testing",
    "1.3.0-using-try-cache-system.exception",
    "1.3.1-using-exception-handling-service",
    "2.0-inclass",
    "2.0-inclass-solution"
)

$successfulBranches = @()
$failedBranches = @()

foreach ($branch in $branches) {
    Write-Host "Processing branch: $branch" -ForegroundColor Yellow
    
    # Checkout branch
    git checkout $branch
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to checkout branch $branch" -ForegroundColor Red
        $failedBranches += "$branch (checkout failed)"
        continue
    }
    
    $filesModified = $false
    
    # Check if .gitignore exists
    if (Test-Path ".gitignore") {
        Write-Host "Found .gitignore file" -ForegroundColor Cyan
        
        $content = Get-Content ".gitignore" -Raw
        $originalContent = $content
        
        # Check if simple .idea/ pattern already exists
        if ($content -notmatch '^\s*\.idea/\s*$') {
            Write-Host "Adding simple .idea/ pattern to .gitignore" -ForegroundColor Green
            
            # Find a good place to insert the JetBrains section
            if ($content -match '### JetBrains\+all ###') {
                # Replace the complex JetBrains section with simple pattern
                $jetbrainsStart = $content.IndexOf('### JetBrains+all ###')
                $jetbrainsEnd = $content.IndexOf('### JetBrains+all Patch ###')
                
                if ($jetbrainsEnd -gt $jetbrainsStart) {
                    # Find the end of the patch section
                    $lines = $content -split "`n"
                    $patchEndIndex = -1
                    $inPatchSection = $false
                    
                    for ($i = 0; $i -lt $lines.Length; $i++) {
                        if ($lines[$i] -match '### JetBrains\+all Patch ###') {
                            $inPatchSection = $true
                        }
                        elseif ($inPatchSection -and $lines[$i] -match '^###') {
                            $patchEndIndex = $i
                            break
                        }
                    }
                    
                    if ($patchEndIndex -gt 0) {
                        $beforeJetBrains = ($lines[0..($jetbrainsStart / 50 - 1)] -join "`n")
                        $afterJetBrains = ($lines[$patchEndIndex..($lines.Length - 1)] -join "`n")
                        
                        $newJetBrainsSection = @"
### JetBrains+all ###
# Covers JetBrains IDEs: IntelliJ, RubyMine, PhpStorm, AppCode, PyCharm, CLion, Android Studio, WebStorm and Rider
# Reference: https://intellij-support.jetbrains.com/hc/en-us/articles/206544839

# JetBrains IDEs (IntelliJ, WebStorm, PhpStorm, etc.)
.idea/

### JetBrains+all Patch ###
# Simple pattern to ignore entire .idea directory

"@
                        $content = $beforeJetBrains + "`n" + $newJetBrainsSection + "`n" + $afterJetBrains
                    }
                }
            }
            else {
                # Add JetBrains section at the beginning
                $newSection = @"
# JetBrains IDEs (IntelliJ, WebStorm, PhpStorm, etc.)
.idea/

"@
                $content = $newSection + $content
            }
            
            $filesModified = $true
        }
        else {
            Write-Host ".idea/ pattern already exists in .gitignore" -ForegroundColor Yellow
        }
        
        if ($content -ne $originalContent) {
            Set-Content ".gitignore" -Value $content -NoNewline
            Write-Host "Updated .gitignore file" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Creating new .gitignore file" -ForegroundColor Green
        $newGitignore = @"
# JetBrains IDEs (IntelliJ, WebStorm, PhpStorm, etc.)
.idea/

"@
        Set-Content ".gitignore" -Value $newGitignore -NoNewline
        $filesModified = $true
    }
    
    # Check if .idea files are tracked and remove them
    $ideaFiles = git ls-files | Where-Object { $_ -like "*.idea*" }
    if ($ideaFiles) {
        Write-Host "Removing tracked .idea files from git..." -ForegroundColor Cyan
        git rm -r --cached .idea/ 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully removed .idea files from tracking" -ForegroundColor Green
            $filesModified = $true
        }
        else {
            Write-Host "No .idea files to remove or already removed" -ForegroundColor Yellow
        }
    }
    
    if ($filesModified) {
        # Try to build the project
        Write-Host "Building project to verify changes..." -ForegroundColor Cyan
        
        # Find solution file or use the first project file for building
        $solutionFile = Get-ChildItem -Recurse -Include "*.sln" | Select-Object -First 1
        if ($solutionFile) {
            Push-Location (Split-Path $solutionFile.FullName)
            dotnet build
            $buildResult = $LASTEXITCODE
            Pop-Location
        } else {
            # Use the first project file
            $projectFiles = Get-ChildItem -Recurse -Include "*.csproj", "*.fsproj", "*.vbproj"
            if ($projectFiles) {
                $firstProject = $projectFiles[0]
                Push-Location (Split-Path $firstProject.FullName)
                dotnet build
                $buildResult = $LASTEXITCODE
                Pop-Location
            }
            else {
                Write-Host "No project files found, skipping build verification" -ForegroundColor Yellow
                $buildResult = 0
            }
        }
        
        if ($buildResult -eq 0) {
            Write-Host "Build successful! Committing changes..." -ForegroundColor Green
            
            # Commit changes
            git add .
            git commit -m "Add .idea/ to .gitignore to exclude JetBrains IDE files"
            
            if ($LASTEXITCODE -eq 0) {
                # Push changes
                git push origin $branch
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "Successfully updated and pushed branch $branch" -ForegroundColor Green
                    $successfulBranches += $branch
                } else {
                    Write-Host "Failed to push branch $branch" -ForegroundColor Red
                    $failedBranches += "$branch (push failed)"
                }
            } else {
                Write-Host "Failed to commit changes for branch $branch" -ForegroundColor Red
                $failedBranches += "$branch (commit failed)"
            }
        } else {
            Write-Host "Build failed for branch $branch. Reverting changes..." -ForegroundColor Red
            git checkout .
            git clean -fd
            $failedBranches += "$branch (build failed)"
        }
    } else {
        Write-Host "No changes needed for branch $branch" -ForegroundColor Yellow
        $successfulBranches += "$branch (no changes needed)"
    }
}

# Summary
Write-Host "`n=== SUMMARY ===" -ForegroundColor Magenta
Write-Host "Successful branches:" -ForegroundColor Green
foreach ($branch in $successfulBranches) {
    Write-Host "  - $branch" -ForegroundColor Green
}

if ($failedBranches.Count -gt 0) {
    Write-Host "`nFailed branches:" -ForegroundColor Red
    foreach ($branch in $failedBranches) {
        Write-Host "  - $branch" -ForegroundColor Red
    }
}
