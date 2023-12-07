<<<<<<< HEAD
#!/usr/bin/bash

set -e # Para o script em caso de erro

check_tools() {
        tool_name=$1

        # Verifica se a ferramenta esta disponivel no sistema
        if command -v "$tool_name" &> /dev/null; then
                echo "[ ✓ ] $tool_name está instalado"
                echo ""
        else
                echo "[ * ] $tool_name não está instalado. Tentando instalar..."
                echo ""

                if [ "$tool_name" == "termux-battery-status" ]; then
                        pkg install termux-api && echo "[ ✓ ] Instalação concluída com sucesso."
                        echo ""
                elif [ "$tool_name" == "jq" ]; then
                        pkg install jq && echo "[ ✓ ] Instalação concluída com sucesso."
                        echo ""
                else
                        echo "[ x ] Ferramenta desconhecida. Não é possível instalar automaticamente."
                        echo ""
                fi
        fi
	
	#Esperar uns 10s para limpar a tela
	sleep 10
        clear
}

get_battery_status() {
        result=$(termux-battery-status)
        charge_level=$(echo "$result" | jq -r '.percentage')

        echo "Nível de carga da tua bateria: $charge_level%"
        echo ""
}

get_network_info() {
        result=$(termux-network-status)
        connect_status=$(echo "$result" | jq -r '.isConnected')

        if [ "$connect_status" == true ]; then
                echo "O dispositivo está conectado à internet."
                echo ""
        else
                echo "O dispositivo não está conectado à internet."
                echo ""
        fi
}

# Chamando as funções
check_tools termux-api
check_tools jq
get_battery_status
get_network_info
=======
#!/usr/biin/bash

>>>>>>> 992d5040aadb7d0bf467ae2d7213dec8e0ce7942
