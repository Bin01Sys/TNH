#!/usr/bin/bash

# Parar o script em caso de erro
set -e

check_tools() {
    tool_name=$1

    # Verifica se a ferramenta está disponível no sistema
    if command -v "$tool_name" &> /dev/null; then
        echo "[ ✓ ] $tool_name está instalado."
    else
        echo "[ * ] $tool_name não está instalado. Tentando instalar..."

        if [ "$tool_name" == "termux-battery-status" ]; then
            pkg install termux-api && echo "[ ✓ ] Instalação concluída com sucesso."
        elif [ "$tool_name" == "jq" ]; then
            pkg install jq && echo "[ ✓ ] Instalação concluída com sucesso."
        else
            echo "[ x ] Ferramenta desconhecida. Não é possível instalar automaticamente."
        fi

        # Adiciona uma pausa de 2 segundos antes de limpar a tela
        sleep 2
        clear
    fi
}

get_battery_status() {
    # Obter o status da bateria
    result=$(termux-battery-status)
    charge_level=$(echo "$result" | jq -r '.percentage')

    echo "Nível de carga da tua bateria: $charge_level%"
}

get_network_info() {
    # Obter informações da rede
    result=$(termux-network-status)
    connect_status=$(echo "$result" | jq -r '.isConnected')

    if [ "$connect_status" == true ]; then
        echo "O dispositivo está conectado à internet."
    else
        echo "O dispositivo não está conectado à internet."
    fi
}

# Chamando as funções
check_tools termux-api
check_tools jq
get_battery_status
get_network_info

