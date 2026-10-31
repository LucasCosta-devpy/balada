@echo off
rem Abre a balada em http://localhost:8080 (o YouTube nao toca se a pagina for aberta direto do arquivo)
cd /d "%~dp0"
start "" http://localhost:8080/
where python >nul 2>&1 && (python -m http.server 8080) || (py -m http.server 8080)
pause
