param (
    [string]$InputPath,
    [string]$OutputPath
)

try {
    if (-not $InputPath) {
        $InputPath = Join-Path -Path (Get-Location) -ChildPath "export.xml"
    }
    if (-not $OutputPath) {
        $OutputPath = Join-Path -Path (Get-Location) -ChildPath "export_last_month.xml"
    }

    $creationDate = (Get-Item $InputPath).CreationTime
    $cutoff = $creationDate.AddDays(-30)

    $settings = New-Object System.Xml.XmlWriterSettings
    $settings.Indent = $true
    $settings.Encoding = [System.Text.Encoding]::UTF8

    $writer = [System.Xml.XmlWriter]::Create($OutputPath, $settings)
    $writer.WriteStartDocument()
    $writer.WriteStartElement("HealthData")

    $readerSettings = New-Object System.Xml.XmlReaderSettings
    $readerSettings.DtdProcessing = [System.Xml.DtdProcessing]::Ignore

    # Begränsa till specifika typer
    $allowedTypes = @(
        "HKQuantityTypeIdentifierStepCount",
        #"HKQuantityTypeIdentifierHeartRate",
        "HKCategoryTypeIdentifierMindfulSession",
        "HKQuantityTypeIdentifierHeartRateVariabilitySDNN",
        "HKQuantityTypeIdentifierDistanceWalkingRunning",
        "HKQuantityTypeIdentifierActiveEnergyBurned",
        "HKQuantityTypeIdentifierBasalEnergyBurned"
    )

    Write-Output "Läser in antal rader i filen först..."
    [int]$totalRecords = 0
    $streamCount = [System.IO.File]::OpenRead($InputPath)
    $readerCount = [System.Xml.XmlReader]::Create($streamCount, $readerSettings)
    while ($readerCount.Read()) {
        if ($readerCount.NodeType -eq [System.Xml.XmlNodeType]::Element -and $readerCount.Name -eq "Record") {
            $totalRecords++
        }
    }
    $readerCount.Close()
    $streamCount.Close()
    Write-Host "`rTotalt $totalRecords poster i originalfilen" -NoNewline

    $stream = [System.IO.File]::OpenRead($InputPath)
    $reader = [System.Xml.XmlReader]::Create($stream, $readerSettings)

    Write-Output "Startar filtrering och export..."
    [int]$processed = 0
    [int]$written = 0

    while ($reader.Read()) {
        if ($reader.NodeType -eq [System.Xml.XmlNodeType]::Element -and $reader.Name -eq "Record") {
            $record = $reader.ReadOuterXml()
            $recordXml = New-Object System.Xml.XmlDocument
            $recordXml.LoadXml($record)

            $startDateStr = $recordXml.DocumentElement.GetAttribute("startDate")
            $type = $recordXml.DocumentElement.GetAttribute("type")

            $parsedDate = [DateTime]::MinValue
            $refDate = [ref]$parsedDate

            if (
                [DateTime]::TryParse($startDateStr, $refDate) -and
                $refDate.Value -ge $cutoff -and
                $allowedTypes -contains $type
            ) {
                $recordXml.DocumentElement.WriteTo($writer)
                $written++
            }

            $processed++
            if ($processed % 100 -eq 0 -or $processed -eq $totalRecords) {
                $percent = [math]::Round(($processed / $totalRecords) * 100, 0)
                Write-Host "`r$processed / $totalRecords poster bearbetade ($percent%)" -NoNewline
            }
        }
    }

    Write-Output "`nFiltrering klar. $written poster skrevs till $OutputPath."

} catch {
    Write-Output "Kunde inte skapa: $OutputPath"
} finally {
    if ($writer) {
        $writer.WriteEndElement()
        $writer.WriteEndDocument()
        $writer.Close()
    }
    if ($stream) {
        $stream.Close()
    }
}
