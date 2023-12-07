REM Autor : Bin01Sys
REM Ajuda recebida de : Zer0G0ld
REM Licença do código GPL-3.0
REM TermuxNotifyHub - Seu Software de Notificação para Termux
REM
REM Copyright (C) [Bin01Sys && Zer0G0ld] [2023]
REM
REM Este programa é software livre: você pode redistribuí-lo e/ou modificá-lo
REM nos termos da Licença Pública Geral GNU conforme publicada pela Free Software
REM Foundation, na versão 3 da Licença, ou (a seu critério) qualquer versão posterior.
REM
REM Este programa é distribuído na esperança de que será útil,
REM mas SEM NENHUMA GARANTIA; sem mesmo a garantia implícita de
REM COMERCIALIZAÇÃO ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO. Consulte a
REM Licença Pública Geral GNU para obter mais detalhes.
REM 
REM Você deve ter recebido uma cópia da Licença Pública Geral GNU
REM junto com este programa. Se não, consulte http://www.gnu.org/licenses/.
REM 
REM =================================================================================


@echo off
cls
echo.
echo.
echo "mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm "
echo "MM                                                                 MM   "
echo "MM                                                                 MM   "
echo "MM                MMP''MM''YMM 7MN.   7MF  7MMF    7MMF            MM   "
echo "MM               P    MM   7   MMN.    M    MM      MM             MM   "
echo "MM                   MM        M YMb   M    MM      MM             MM   "
echo "MM                   MM        M  MN. M    MMmmmmmmMM              MM   "
echo "MM                   MM        M   MM.M    MM      MM              MM   "
echo "MM                  MM        M     YMM    MM      MM              MM   "
echo "MM                .JMML.    .JML.    YM  .JMML.  .JMML.            MM   "
echo "MM                                                                 MM   "
echo "MM     AUTOR  : BIN01SYS AND ZER0G0LD                              MM   " 
echo "MM     GITHUB BINSYS : https://github.com/Bin01Sys                 MM   "  
echo "MM     GITHUB ZER0G0LD : https://github.com/Zer0G0ld               MM   "
echo "MM                                                                 MM   "
echo "mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm mmmmmmm "
echo.

REM Parar o script em caso de erro
@setlocal enabledelayedexpansion
set "error=false"

:install_tool
    set "tool_name=%1"
    echo [ * ] %tool_name% não está instalado. Tentando instalar...
    
    if /I "%tool_name%"=="termux-battery-status" (
        echo pkg install termux-api
    ) else (
        if /I "%tool_name%"=="jq" (
            echo pkg install jq
        ) else (
            echo [ x ] Ferramenta desconhecida. Não é possível instalar automaticamente.
            set "error=true"
        )
    )

    if not !error! == true (
        echo [ ✓ ] Instalação concluída com sucesso para %tool_name%.
    ) else (
        echo [ x ] Falha na instalação para %tool_name%.
        exit /b 1
    )

:check_and_install
    set "tool_name=%1"
    REM Verifica se a ferramenta está disponível no sistema
    where "%tool_name%" >nul 2>nul || call :install_tool "%tool_name%"

:get_battery_status
    REM Obter o status da bateria
    for /f "delims=" %%a in ('termux-battery-status') do set "result=%%a"
    for /f "tokens=2 delims=: " %%b in ('echo %result% ^| jq -r ".percentage"') do set "charge_level=%%b"

    echo Nível de carga da tua bateria: %charge_level%%
    REM Notificar quando a bateria atingir 20%
    if %charge_level% leq 20 (
        termux-notification --title "Bateria Baixa" --content "A bateria está em %charge_level%%. Carregue o dispositivo."
    )

:get_network_info
    REM Obter informações da rede
    call :check_and_install termux-network-status

    for /f "delims=" %%a in ('termux-network-status') do set "result=%%a"
    for /f "tokens=2 delims=: " %%c in ('echo %result% ^| jq -r ".isConnected"') do set "connect_status=%%c"

    if "%connect_status%"=="true" (
        echo O dispositivo está conectado à internet.
    ) else (
        echo O dispositivo não está conectado à internet.
        termux-notification --title "Sem Conexão de Rede" --content "O dispositivo está sem conexão de rede."
    )

:end
    endlocal
