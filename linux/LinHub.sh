# Autor : Bin01Sys
# Ajuda recebida de : Zer0G0ld
# Licença do código GPL-3.0
# TermuxNotifyHub - Seu Software de Notificação para Termux
#
# Copyright (C) [Bin01Sys && Zer0G0ld] [2023]
#
# Este programa é software livre: você pode redistribuí-lo e/ou modificá-lo
# nos termos da Licença Pública Geral GNU conforme publicada pela Free Software
# Foundation, na versão 3 da Licença, ou (a seu critério) qualquer versão posterior.
#
# Este programa é distribuído na esperança de que será útil,
# mas SEM NENHUMA GARANTIA; sem mesmo a garantia implícita de
# COMERCIALIZAÇÃO ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO. Consulte a
# Licença Pública Geral GNU para obter mais detalhes.
# 
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa. Se não, consulte http://www.gnu.org/licenses/.
# 
# =======================================================

#!/bin/bash

echo ""
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
echo ""

# Parar o script em caso de erro
set -e

install_tool() {
    local tool_name=$1
    echo "[ * ] $tool_name não está instalado. Tentando instalar..."
    
    case $tool_name in
        "jq") 
            sudo apt-get install jq ;;
        *) 
            echo "[ x ] Ferramenta desconhecida. Não é possível instalar automaticamente." ;;
    esac

    if [ $? -eq 0 ]; then
        echo "[ ✓ ] Instalação concluída com sucesso para $tool_name."
    else
        echo "[ x ] Falha na instalação para $tool_name."
        exit 1
    fi
}

check_and_install() {
    local tool_name=$1
    # Verifica se a ferramenta está disponível no sistema
    command -v "$tool_name" &> /dev/null || install_tool "$tool_name"
}

get_battery_status() {
    # Obter o status da bateria
    local charge_level=$(acpi | awk '{print $4}' | tr -d ',')

    echo "Nível de carga da tua bateria: $charge_level%"
    # Notificar quando a bateria atingir 20%
    [ "$charge_level" -le 20 ] && notify-send "Bateria Baixa" "A bateria está em $charge_level%. Carregue o dispositivo."
}

get_network_info() {
    # Obter informações da rede
    local connect_status=$(ping -q -c 1 -W 1 8.8.8.8 > /dev/null && echo "online" || echo "offline")

    if [ "$connect_status" == "online" ]; then
        echo "O dispositivo está conectado à internet."
    else
        echo "O dispositivo não está conectado à internet."
        notify-send "Sem Conexão de Rede" "O dispositivo está sem conexão de rede."
    fi
}

# Chamando as funções
check_and_install jq
get_battery_status
get_network_info
