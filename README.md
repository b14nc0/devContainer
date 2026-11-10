# devContainer

Plantilla de [Dev Container](https://containers.dev/) para trabajar con infraestructura como código y Kubernetes.

Parte de una imagen Ubuntu 24.04 mínima con Docker-in-Docker, y cada herramienta se activa con una variable en `devcontainer.json`: el contenedor solo instala lo que necesitas.

## Qué incluye

**Siempre**, en la imagen base:

- ssh, curl, wget, zip, vim, less, gnupg, jq, yq, watch
- Utilidades de red: netcat, iproute2, ping
- Docker-in-Docker, mediante la feature `ghcr.io/devcontainers/features/docker-in-docker:2`

**Opcionales**, activables desde `containerEnv`:

| Variable | Herramienta | Notas |
|---|---|---|
| `INSTALL_AZURECLI` | Azure CLI | Incluye `az aks install-cli` (kubectl y kubelogin) |
| `INSTALL_AWSCLI` | AWS CLI v2 | |
| `INSTALL_KUBECTL` | kubectl | Última versión estable |
| `INSTALL_HELM` | Helm 3 | |
| `INSTALL_TERRAFORM` | Terraform | Versión en `TERRAFORM_VERSION` (por defecto `1.8.1*`) |
| `INSTALL_TERRAGRUNT` | Terragrunt | Versión en `TERRAGRUNT_VERSION` (por defecto `v0.77.17`); si la dejas vacía, instala la última |
| `INSTALL_GH` | GitHub CLI | Para GitHub Enterprise, define también `GH_HOST` |
| `INSTALL_OPENCODE` | OpenCode | Necesita Node.js: actívalo junto a `INSTALL_OPENSPEC`, que lo instala |
| `INSTALL_OPENSPEC` | OpenSpec | Instala Node.js 20 si no está disponible |
| `INSTALL_KIND` | kind v0.30.0 | Clústeres de Kubernetes locales |

Todas vienen a `false` por defecto.

## Requisitos

- [Visual Studio Code](https://code.visualstudio.com/) con la extensión [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- Docker
- Las carpetas `~/.ssh` y `~/.config/gh` deben existir en tu máquina. El contenedor las monta para reutilizar tus claves SSH y tu sesión de `gh`, y si alguna no existe, no arranca.

## Uso

1. Clona la plantilla:

   ```bash
   git clone https://github.com/b14nc0/devContainer.git mi-proyecto
   cd mi-proyecto
   ```

2. Activa las herramientas que quieras en `.devcontainer/devcontainer.json`:

   ```jsonc
   "containerEnv": {
     "INSTALL_KUBECTL": "true",
     "INSTALL_HELM": "true",
     "INSTALL_TERRAFORM": "true",
     "TERRAFORM_VERSION": "1.8.1*"
   }
   ```

3. Ábrelo en VS Code y elige **Dev Containers: Reopen in Container**.

Al terminar, `post-create.sh` muestra un resumen con lo que se ha instalado y sus versiones.

## Estructura

```
.devcontainer/
├── devcontainer.json       # Imagen, features, montajes y variables INSTALL_*
├── devcontainer-lock.json  # Versión fijada de la feature de Docker-in-Docker
├── dockerfile              # Ubuntu 24.04 con las utilidades base
├── config/                 # Ficheros de configuración propios
└── script/
    └── post-create.sh      # Instala las herramientas activadas
```

## Qué más hace `post-create.sh`

Además de instalar herramientas, en cada creación del contenedor:

- Añade `8.8.8.8` como servidor DNS en `/etc/resolv.conf`.
- Marca todos los directorios como seguros para Git (`safe.directory '*'`), para evitar errores de propiedad en volúmenes montados.
- Crea el alias `k` para `kubectl`.

## Añadir una herramienta

1. Crea una función en `script/post-create.sh`:

   ```bash
   function installMiHerramienta(){
       # instalación
   }
   ```

2. Llámala condicionada a una variable:

   ```bash
   [ "$INSTALL_MIHERRAMIENTA" = "true" ] && installMiHerramienta
   ```

3. Añade `"INSTALL_MIHERRAMIENTA": "false"` a `containerEnv` en `devcontainer.json`.

## Licencia

MIT. Ver [LICENSE](LICENSE).

## Autor

Jorge Blanco · [@b14nc0](https://github.com/b14nc0)
