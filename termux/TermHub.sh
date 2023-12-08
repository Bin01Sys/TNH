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
# =================================================================================

#!/bin/bash

# Função para exibir mensagem com borda
print_banner() {
    cat << "EOF"
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
M                  _______  _   _  _    _                 M
M                 |__   __|| \ | || |  | |                M
M                    | |   |  \| || |__| |                M
M                    | |   |     ||  __  |                M
M                    | |   | |\  || |  | |                M
M                    |_|   |_| \_||_|  |_|                M
M                                                         M
M   AUTOR  : BIN01SYS AND ZER0G0LD                        M
M   GITHUB BINSYS : https://github.com/Bin01Sys           M
M   GITHUB ZER0G0LD : https://github.com/Zer0G0ld         M
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
EOF
}

# Função para instalar ferramenta se não estiver instalada
install_tool() {
    local tool_name=$1
    echo "[ * ] $tool_name não está instalado. Tentando instalar..."

    case $tool_name in
        "termux-battery-status") pkg install termux-api ;;
        "jq") pkg install jq ;;
        *) echo "[ x ] Ferramenta desconhecida. Não é possível instalar automaticamente." ;;
    esac

    if [ $? -eq 0 ]; then
        echo "[ ✓ ] Instalação concluída com sucesso para $tool_name."
    else
        echo "[ x ] Falha na instalação para $tool_name."
        exit 1
    fi
}

# Função para verificar e instalar ferramenta
check_and_install() {
    local tool_name=$1
    command -v "$tool_name" &> /dev/null || install_tool "$tool_name"
}

# Função para obter o status da bateria e notificar se estiver baixa
get_battery_status() {
    local result=$(termux-battery-status)
    local charge_level=$(echo "$result" | jq -r '.percentage')

    echo "Nível de carga da tua bateria: $charge_level%"
    
    if [ "$charge_level" -le 20 ]; then
        termux-notification --title "Bateria Baixa" --content "A bateria está em $charge_level%. Carregue o dispositivo."
    fi
}

# Função para obter informações da rede e notificar se não houver conexão
get_network_info() {
    check_and_install termux-network-status

    local result=$(termux-network-status)
    local connect_status=$(echo "$result" | jq -r '.isConnected')

    if [ "$connect_status" == true ]; then
        echo "O dispositivo está conectado à internet."
    else
        echo "O dispositivo não está conectado à internet."
        termux-notification --title "Sem Conexão de Rede" --content "O dispositivo está sem conexão de rede."
    fi
}

# Executando as funções
echo -e "\n\n"
print_banner
echo -e "\n\n"

set -e  # Parar o script em caso de erro

check_and_install termux-api
check_and_install jq
get_battery_status
get_network_info


