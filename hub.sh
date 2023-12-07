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
# ================================================

#!/usr/bin/bash

# Parar o script em caso de erro
set -e



install_tool() {
    tool_name=$1
    echo "[ * ] $tool_name não está instalado. Tentando instalar..."
    
    case $tool_name in
        "termux-battery-status") pkg install termux-api ;;
        "jq") pkg install jq ;;
        *) echo "[ x ] Ferramenta desconhecida. Não é possível instalar automaticamente." ;;
    esac

    echo "[ ✓ ] Instalação concluída com sucesso para $tool_name."
}

check_and_install() {
    tool_name=$1
    # Verifica se a ferramenta está disponível no sistema
    command -v "$tool_name" &> /dev/null || install_tool "$tool_name"
}

get_battery_status() {
    # Obter o status da bateria
    result=$(termux-battery-status)
    charge_level=$(echo "$result" | jq -r '.percentage')

    echo "Nível de carga da tua bateria: $charge_level%"
    # Notificar quando a bateria atingir 20%
    [ "$charge_level" -le 20 ] && termux-notification --title "Bateria Baixa" --content "A bateria está em $charge_level%. Carregue o dispositivo."
}

get_network_info() {
    # Obter informações da rede
    result=$(termux-network-status)
    connect_status=$(echo "$result" | jq -r '.isConnected')

    if [ "$connect_status" == true ]; then
        echo "O dispositivo está conectado à internet."
    else
        echo "O dispositivo não está conectado à internet."
        termux-notification --title "Sem Conexão de Rede" --content "O dispositivo está sem conexão de rede."
    fi
}

# Chamando as funções
check_and_install termux-api
check_and_install jq
get_battery_status
get_network_info




