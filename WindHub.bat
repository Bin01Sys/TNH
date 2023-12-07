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

echo.
echo.
echo "Bem-vindo ao Seu Software de Notificação para Windows"
echo.

REM Obter o nível de carga da bateria
for /f "tokens=2 delims=: " %%a in ('wmic path Win32_Battery get EstimatedChargeRemaining ^| findstr /r "."') do set "charge_level=%%a"

echo Nível de carga da bateria: %charge_level%

REM Notificar quando a bateria atingir 20%
if %charge_level% leq 20 (
    msg * A bateria está em %charge_level%%. Carregue o dispositivo.
)

REM Verificar a conexão de rede
ping -n 1 google.com >nul
if errorlevel 1 (
    echo O dispositivo não está conectado à internet.
    msg * O dispositivo está sem conexão de rede.
) else (
    echo O dispositivo está conectado à internet.
)

pause

