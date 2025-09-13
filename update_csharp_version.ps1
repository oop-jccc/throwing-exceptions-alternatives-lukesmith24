# PowerShell script to update C# language version from 10 to 12 across all branches

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
    
    # Find all project files
    $projectFiles = Get-ChildItem -Recurse -Include "*.csproj", "*.fsproj", "*.vbproj"
    
    if ($projectFiles.Count -eq 0) {
        Write-Host "No project files found in branch $branch" -ForegroundColor Yellow
        continue
    }
    
    $filesModified = $false
    
    foreach ($projectFile in $projectFiles) {
        Write-Host "Checking project file: $($projectFile.FullName)" -ForegroundColor Cyan
        
        $content = Get-Content $projectFile.FullName -Raw
        $originalContent = $content
        
        # Check if LangVersion is set to 10 or 10.0 and update to 12
        if ($content -match '<LangVersion>\s*10(\.0)?\s*</LangVersion>') {
            $content = $content -replace '<LangVersion>\s*10(\.0)?\s*</LangVersion>', '<LangVersion>12</LangVersion>'
            $filesModified = $true
            Write-Host "Updated LangVersion from 10 to 12 in $($projectFile.Name)" -ForegroundColor Green
        }
        # If no LangVersion property exists, add it to ensure C# 12
        elseif ($content -notmatch '<LangVersion>') {
            # Find PropertyGroup and add LangVersion
            if ($content -match '(\s*)<PropertyGroup>') {
                $indent = $matches[1]
                $content = $content -replace '(\s*<PropertyGroup>\s*\n)', "`$1$indent    <LangVersion>12</LangVersion>`n"
                $filesModified = $true
                Write-Host "Added LangVersion 12 to $($projectFile.Name)" -ForegroundColor Green
            }
        }
        
        if ($content -ne $originalContent) {
            Set-Content $projectFile.FullName -Value $content -NoNewline
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
            $firstProject = $projectFiles[0]
            Push-Location (Split-Path $firstProject.FullName)
            dotnet build
            $buildResult = $LASTEXITCODE
            Pop-Location
        }

        if ($buildResult -eq 0) {
            Write-Host "Build successful! Committing changes..." -ForegroundColor Green
            
            # Commit changes
            git add .
            git commit -m "Update C# language version from 10 to 12"
            
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
