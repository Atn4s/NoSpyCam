#!/bin/bash

# CamCtrl.sh - Script para controlar a webcam
# Este script permite habilitar, desabilitar e verificar o status da webcam.
# Certifique-se de executar como root/superusuário para garantir as permissões necessárias.

# Função para exibir o menu
show_menu() {
    figlet "CamCtrl.sh"
    echo "Gerencie sua webcam com facilidade!"
    echo "===== Menu Webcam ====="
    echo "1. Habilitar webcam"
    echo "2. Desabilitar webcam"
    echo "3. Sair"
    echo "======================="
}

# Função para habilitar a webcam
enable_webcam() {
    echo "Habilitando a webcam..."
    modprobe uvcvideo
    echo "Acesso à webcam habilitado."
}

# Função para desabilitar a webcam
disable_webcam() {
    echo "Desabilitando a webcam..."

    # Verifica se algum processo está usando a webcam
    if lsof /dev/video0 >/dev/null 2>&1; then
        echo "Aplicativo(s) está(ão) usando a webcam:"
        lsof /dev/video0
        echo "Deseja encerrar o(s) aplicativo(s)? (S/N): "
        read -r response

        if [[ $response =~ ^[Ss]$ ]]; then
            echo "Encerrando o(s) aplicativo(s) que está(ão) usando a webcam..."
            fuser -k /dev/video0
            sleep 2 # Aguarda um breve momento para garantir que o aplicativo seja encerrado
        else
            echo "Operação cancelada. A webcam não será desabilitada."
            return
        fi
    fi

    modprobe -r uvcvideo
    echo "Acesso à webcam desabilitado."
}

# Função para verificar o status da webcam
check_webcam_status() {
    if lsmod | grep -q uvcvideo; then
        echo "A webcam está atualmente: habilitada"
    else
        echo "A webcam está atualmente: desabilitada"
    fi
}

# Verifica se o usuário é root
if [[ $EUID -ne 0 ]]; then
    echo "Este script precisa ser executado como root/superusuário."
    exit 1
fi

# Exibe o status da webcam no início do script
check_webcam_status

while true; do
    show_menu
    read -p "Escolha uma opção (1/2/3): " choice

    case $choice in
        1)
            enable_webcam
            ;;
        2)
            disable_webcam
            ;;
        3)
            echo "Saindo do menu."
            break
            ;;
        *)
            echo "Opção inválida. Escolha novamente."
            ;;
    esac
done

