#!/usr/bin/env bash
#Description: Install to dependencies tools  ubuntu 22
#Author: Jorge Blanco (b14nc0)
#Fecha: 20250818
#Version: 1.0.3
#https://github.com/terraform-docs/terraform-docs/releases/tag/v0.14.1


function configDns(){ 

    ## Configuracion de resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf

}
function configGit(){
    # Configurar Git para evitar problemas de ownership en dev containers
    git config --global --add safe.directory '*'
    echo "Git configurado para permitir todos los directorios como seguros"
}

function installAzureCli(){
    #Intala azureCli
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
    az aks install-cli

}

function installAwsCli(){
    #Instala awsCli
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    bash -c ./aws/install
    rm -rf aws awscliv2.zip 
}

function installKubectl(){
    #Instala kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /bin/kubectl
    ## Configuracion de alias
    
}
function installHelm(){
    #Instala Helm
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
}

function installTerraform(){
    #Instala Terraform
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |  tee /etc/apt/sources.list.d/hashicorp.list
    apt update
    if [ "$TERRAFORM_VERSION" ]; then
        echo "Instalando Terraform version $TERRAFORM_VERSION"
        apt install terraform=${TERRAFORM_VERSION}
    else
        echo "No se ha especificado una versión de Terraform. Se instalará la última versión disponible."
        TERRAFORM_VERSION=""
        apt install terraform
    fi
}

function installTerragrunt(){
    #Instala Terragrunt
    if [ -z "$TERRAGRUNT_VERSION" ]; then
        echo "No se ha especificado una versión de Terragrunt. Se instalará la última versión disponible."
        # Obtener la última versión desde GitHub API
        TERRAGRUNT_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        echo "Última versión disponible: $TERRAGRUNT_VERSION"
    fi
    curl -sLo terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64
    chmod +x terragrunt
    mv terragrunt /bin/terragrunt
}
function installGhCli(){
    #Instala GitHub CLI (gh)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
        https://cli.github.com/packages stable main" \
        | tee /etc/apt/sources.list.d/github-cli.list
    apt update && apt install gh -y
    # Si usas GitHub Enterprise, define GH_HOST en containerEnv
    [ -n "$GH_HOST" ] && echo "export GH_HOST=$GH_HOST" >> /root/.bashrc
}

function installOpencode(){
    #Instala OpenCode
    npm i -g opencode-ai
}

function installOpenspec(){
    #Instala OpenSpec (requiere Node.js 20+)
    # Instalar Node.js 20 LTS si no está disponible o es menor que 20
    if ! command -v node >/dev/null || [ "$(node -e 'console.log(parseInt(process.version.slice(1)))')" -lt 20 ]; then
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
        apt-get install -y nodejs
    fi
    npm install -g @fission-ai/openspec@latest
}

function kindInstall(){

    # For AMD64 / x86_64
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64
    # For ARM64
    [ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-arm64
    chmod +x ./kind
    mv ./kind /usr/local/bin/kind
}

function aliases(){
    cat <<EOL >> /root/.bashrc
alias k='kubectl'
EOL

}

echo Configurando el contenedor...
# obligatorio

configDns
configGit
aliases

# opcional
[ "$INSTALL_AZURECLI" = "true" ] && installAzureCli
[ "$INSTALL_AWSCLI" = "true" ] && installAwsCli
[ "$INSTALL_KUBECTL" = "true" ] && installKubectl
[ "$INSTALL_HELM" = "true" ] && installHelm
[ "$INSTALL_TERRAFORM" = "true" ] && installTerraform
[ "$INSTALL_TERRAGRUNT" = "true" ] && installTerragrunt
[ "$INSTALL_GH" = "true" ] && installGhCli
[ "$INSTALL_OPENCODE" = "true" ] && installOpencode
[ "$INSTALL_OPENSPEC" = "true" ] && installOpenspec
[ "$INSTALL_KIND" = "true" ] && kindInstall # sirve para crear clusters locales de kubernetes


echo "Configuración finalizada."
echo "----------------------------------------"
echo -e \n

GREEN='\033[0;32m'
NC='\033[0m' # Sin color

echo "----------------------------------------"
echo "Resumen de instalación:"
echo "----------------------------------------"

echo -e "${GREEN}✔ Configuración de DNS realizada${NC}"
echo -e "${GREEN}✔ Git configurado para usar SSH${NC}"

# Verificar herramientas opcionales basadas en variables de entorno
[ "$INSTALL_AZURECLI" = "true" ] && command -v az >/dev/null && echo -e "${GREEN}✔ Azure CLI instalado${NC}"
[ "$INSTALL_AWSCLI" = "true" ] && command -v aws >/dev/null && echo -e "${GREEN}✔ AWS CLI instalado${NC}"
[ "$INSTALL_KUBECTL" = "true" ] && command -v kubectl >/dev/null && echo -e "${GREEN}✔ Kubectl instalado${NC}"
[ "$INSTALL_HELM" = "true" ] && command -v helm >/dev/null && echo -e "${GREEN}✔ Helm instalado${NC}"
[ "$INSTALL_TERRAFORM" = "true" ] && command -v terraform >/dev/null && echo -e "${GREEN}✔ Terraform instalado${NC}"
[ "$INSTALL_TERRAGRUNT" = "true" ] && command -v terragrunt >/dev/null && echo -e "${GREEN}✔ Terragrunt instalado${NC}"
[ "$INSTALL_GH" = "true" ] && command -v gh >/dev/null && echo -e "${GREEN}✔ GitHub CLI (gh) instalado${NC}"
[ "$INSTALL_OPENCODE" = "true" ] && command -v opencode >/dev/null && echo -e "${GREEN}✔ OpenCode instalado${NC}"
[ "$INSTALL_OPENSPEC" = "true" ] && command -v openspec >/dev/null && echo -e "${GREEN}✔ OpenSpec instalado${NC}"
[ "$INSTALL_KIND" = "true" ] && command -v kind >/dev/null && echo -e "${GREEN}✔ kind instalado y clúster creado${NC}"


echo "----------------------------------------"
echo "Versiones instaladas:"
echo "----------------------------------------"

command -v terraform >/dev/null && echo -n "Terraform: " && terraform version | head -n 1
command -v terragrunt >/dev/null && echo -n "Terragrunt: " && terragrunt --version | head -n 1
command -v kubectl >/dev/null && echo -n "Kubectl: " && kubectl version --client | head -n 1
command -v helm >/dev/null && echo -n "Helm: " && helm version --short
command -v aws >/dev/null && echo -n "AWS CLI: " && aws --version 
command -v az >/dev/null && echo -n "Azure CLI: " && az version | head -n 1
command -v gh >/dev/null && echo -n "GitHub CLI: " && gh --version | head -n 1
command -v opencode >/dev/null && echo -n "OpenCode: " && opencode --version
command -v openspec >/dev/null && echo -n "OpenSpec: " && openspec --version
command -v kind >/dev/null && echo -n "kind: " && kind version | head -n 1
command -v git >/dev/null && echo -n "Git username: " && git config -l | grep user.name
command -v git >/dev/null && echo -n "Git email: " && git config -l | grep user.email   
echo "----------------------------------------"
