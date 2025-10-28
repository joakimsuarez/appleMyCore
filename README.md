# appleMyCore
Delad Swift-modul för modeller, protokoll och kärnlogik.  
Utvecklas och testas på Windows (ARM64) och används i Xcode via Swift Package Manager.

Filstruktur:
C:\DROPBOX\UTVECKLING\APPLEMYCORE
├───Sources
│   ├───appleMyCore
│   │   ├───Apple
│   │   ├───Models
│   │   ├───Protocols
│   │   ├───Views
│   │   │   ├───iPhone
│   │   │   └───Watch
│   │   └───Windows
│   └───appleMyCoreCLI
├───SuarezHealth
│   ├───iPhoneApp
│   │   └───Assets.xcassets
│   │       ├───AccentColor.colorset
│   │       └───AppIcon.appiconset
│   ├───SuarezHealth.xcodeproj
│   └───WatchApp
│       └───Assets.xcassets
│           ├───AccentColor.colorset
│           └───AppIcon.appiconset
└───Tests
    └───appleMyCoreTests

# appleMyCoreCLI
Kommandoradsverktyg för att läsa Apple Health-exporter via `HealthExportReader`.
## Användning
Lägg `export.xml` i `Resources`-mappen.
Kör:
```bash
swift run appleMyCoreCLI HeartRate --from 2025-10-01 --to 2025-10-26
