# Martina's Azure MVC App

Detta projekt är en del av **Inlämning 1 - Grundläggande molnapplikationer**. Det innehåller en ASP.NET Core MVC-applikation som är driftsatt på en virtuell Ubuntu-maskin i Azure med hjälp av Infrastructure as Code (Bicep).

## 🚀 Snabbfakta
- **Framework:** .NET 8.0 (MVC)
- **Host:** Azure VM (Ubuntu 22.04 LTS)
- **Infrastructure:** Bicep
- **CI/CD:** GitHub Actions (YAML)

## 📁 Projektstruktur
- `/Exam1`: Webblösningens källkod.
- `/Infra`: Bicep-filer och parametrar för att skapa Azure-miljön.
- `/.github/workflows`: Automatiseringsflöde för driftsättning.

## 🛠️ Installation & Driftsättning
1. **Provisionera:** Kör `az deployment group create` med filerna i `/Infra`.
2. **Konfigurera:** Installera .NET 8 på servern och kör `setcap` för port 80.
3. **Publicera:** Använd `dotnet publish` och ladda upp via `scp` eller använd medföljande GitHub Action.

## 🌐 Status
Applikationen har verifierats i Azure men resurserna har avetablerats för att minimera kostnader. 
Se rapporten för skärmdumpar på den fungerande miljön.
