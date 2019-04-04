#########################
# Módulo de Funções
#########################

_CLEAN_BUFFER()
{
    clear
    _MENU
}

CTRL_C()
{
    echo
    echo -e "${red}Se você deseja sair, não esqueça de fechar a loja!${end}"
    echo -e "${red}É de extrema importância, para gerar a criptografia.${end}"
    echo -e "${red}Para sair com segurança digite: end ou quit${end}"
    return 0
}

#=========================
# MENU
#=========================

# Módulo de menu
_MENU()
{
    local inc='0'

    # Calculando quantas bancas existem na loja
    pushd "${HOME}/.${PRG}" &>/dev/null
    for calculate in *; do
        [[ "$calculate" != '*' ]] && inc=$(($inc + 1))
    done
    popd &>/dev/null
    # Imprimindo linha adaptavel com dados
    printf '%b\n' "| ${PRG} - ${VERSION} | Número de Bancas na Loja: ${red}[${inc}]${end}"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

#=========================
# CRIPTOGRAFIA
#=========================
# Módulo para criptografar
_CRYPT()
{
    pushd "${HOME}" &>/dev/null
    if tar -czf - ".${PRG}" | openssl enc -e -aes256 -out ".${PRG}${EXT}"; then
        rm -r ".${PRG}"
        printf '%s\n' "A loja foi fechada."
        return 0
    fi
}


# Módulo para descriptografar
_DECRYPT()
{
    # Descriptografando Data.
    pushd "${HOME}" &>/dev/null
    if [[ ! -e ".${PRG}${EXT}" ]]; then
        echo "Não Encontrei a sua Loja em ${HOME}."
        exit 1
    else
        openssl enc -d -aes256 -in ".${PRG}${EXT}" | tar xz || return 1
    fi
}

#=========================
# CRIAÇÃO
#=========================

# Criação de uma nova banca
_CREATE()
{
    local newbank="$1"

    pushd "${HOME}/.${PRG}" &>/dev/null
    if [[ ! -e "${HOME}/.${PRG}/${newbank}" ]] || [[ ! -e "${HOME}/.${PRG}/${newbank}" ]]; then
        # Criando nova banca
        echo "########################################################" >> "${HOME}/.${PRG}/${newbank}"
        echo "# Banca $newbank"                                         >> "${HOME}/.${PRG}/${newbank}"
        echo "########################################################" >> "${HOME}/.${PRG}/${newbank}"
        echo "Sua nova banca foi criada..."
        sleep 2s
        _CLEAN_BUFFER
    else
        printf '%s\n' "A banca ${newbank} já existe."
        return 1
    fi
}

#=========================
# ABRIR
#=========================

_OPEN()
{
    local receive="$1"
    
    [[ ! -e "${HOME}/.${PRG}/$receive" ]] && { printf '%s\n' "Está Banca NÃO existe."; return 1 ;}
    $EDITOR "$receive" && return 0
}

#=========================
# IMPRIMIR
#=========================

_PRINTALL()
{
    local print
    
    pushd "${HOME}/.${PRG}" &>/dev/null
    for print in *; do
        if [[ "$print" = '*' ]]; then
            printf '%s\n' "Não Há bancas disponiveis."
            return 1
        else
            printf '%s\n' "Estas são as suas bancas disponiveis:"
        fi
        printf '%b\n' "${red}Banca:${end} $print"
    done
    popd &>/dev/null
    return 0
}
