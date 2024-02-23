echo -e "\033[0;31m

          ___ ___             __   __   ___
    |\/| |__   |   /\   |\/| /  \ |__) |__
    |  | |___  |  /~~\  |  | \__/ |  \ |___

\033[0m"

echo -e "\e[31mEscolha uma opção:\e[0m"
options=("BUSCAR POR ARQUIVOS DE PDF, DOC, JPG, PNG, DOCX, XML, XLSX" "Sair")

echo -e "\033[0;32mEssa ferramenta busca por vários formatos de arquivos ocultos em endpoints, baixa tudo sem usar multithreading e caça seus metadados de forma recursiva\e[0m"

select opt in "${options[@]}"
do
    case $REPLY in
        1)
            echo "Você escolheu a opção 1. Executando o script..."
            read -p "Digite o nome do arquivo que contém as URLs: " url_file
            read -p "Digite o nome da pasta para os downloads: " folder_name

            # Criar a pasta de downloads se não existir
            mkdir -p "$folder_name"

            # Baixar os arquivos e salvá-los na pasta especificada
            cat "$url_file" | waybackurls | grep -E ".pdf$|.doc$|.jpg$|.png$|.docx$|.xml$|.xlsx$" | while read -r url; do
                ((count++))
                echo -e "\e[34mBaixando: $url\e[0m"
                wget "$url" -O "$folder_name/file_$count.$(echo $url | awk -F . '{print $NF}')"
            done

            # Certificar-se de estar no diretório onde os arquivos foram baixados
            cd "$folder_name"

            # Loop através de todos os arquivos no diretório atual
            for file in *; do
                echo "Analisando $file:"
                exiftool "$file" | egrep -i "Author|Creator|Email|Producer|Template" | sort -u
                echo "----------------------------------------------------------------"
            done
            ;;
        2)
            echo "Você escolheu a opção 2. Saindo..."
            break
            ;;
        *)
            echo "Opção inválida: $REPLY. Por favor, escolha uma opção válida."
            ;;
    esac
done

