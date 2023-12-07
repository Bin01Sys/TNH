# Autor : Bin01Sys
# Ajuda recebida de : Zer0G0ld
# Licença do código GPL-3.0

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

check_tools() {
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
check_tools termux-api
check_tools jq
get_battery_status
get_network_info


