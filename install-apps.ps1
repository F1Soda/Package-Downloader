param (
    [Parameter(Mandatory = $true)]
    [string]$PackageFilePaths
)

$paths = $PackageFilePaths -split '\s+'

foreach ($filePath in $paths) {
    $filePath = $filePath.Trim()
    if ([string]::IsNullOrWhiteSpace($filePath)) {
        continue
    }

    if (Test-Path $filePath) {
        Write-Host "`n--- Downloading from $filePath ---"

        $packageIds = Get-Content $filePath | Where-Object { $_ -and -not ($_.TrimStart().StartsWith('#')) }

        # Удаляем дубликаты и лишние пробелы
        $uniqueIds = $packageIds | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" } | Sort-Object -Unique

        foreach ($id in $uniqueIds) {
            Write-Host "`nDownloading $id" -ForegroundColor Yellow
            winget install --id $id --accept-source-agreements --accept-package-agreements
        }
    } else {
        Write-Warning "File not found: $filePath"
    }
}

