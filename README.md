# DevContainer Template - Entorno de Desarrollo para Infrastructure as Code

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)

## 📋 Descripción

Este es un **template de DevContainer** diseñado para proporcionar un entorno de desarrollo completo, consistente y reproducible para proyectos de **Infrastructure as Code (IaC)**. Incluye todas las herramientas esenciales pre-configuradas para trabajar con Terraform, Kubernetes, Azure y AWS.

## ✨ Características

- 🐳 **Entorno containerizado** con Visual Studio Code Dev Containers
- 🔧 **Instalación automática** de herramientas mediante scripts y features
- 📊 **Resumen visual** del estado de instalación
- 🎨 **Configuración personalizable** según necesidades del proyecto
- 🚀 **Inicio rápido** en menos de 5 minutos

## 🛠️ Herramientas Incluidas

### Infrastructure as Code
- **Terraform** `v1.5.1`
- **Terragrunt** `v0.77.17`

### Kubernetes & Container Orchestration
- **kubectl**
- **Helm**

### Cloud Providers
- **Azure CLI**
- **AWS CLI** (opcional)

### Herramientas de Desarrollo
- **Git**, **SSH**, **jq/yq**, **curl/wget**, **vim**

## 🚀 Inicio Rápido

### Prerrequisitos

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker Desktop / Docker Engine](https://www.docker.com/products/docker-desktop)
- [Extensión Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Uso del Template

1. **Crear proyecto**
   ```bash
   git clone https://github.com/tu-usuario/devContainer-template.git mi-proyecto
   cd mi-proyecto
   ```
2. **Abrir en VS Code**
   ```bash
   code .
   ```
3. **Reabrir en contenedor**
   - Notificación: Reopen in Container
   - O: `Ctrl+Shift+P` → Dev Containers: Reopen in Container
4. **Esperar instalación**
   - Build + postCreateCommand
   - Resumen final en terminal

## 📁 Estructura del Proyecto

```
devContainer/
├── .devcontainer/
│   ├── devcontainer.json
│   └── script/
│       └── post-create.sh
├── README.md
└── LICENSE
```

## ⚙️ Personalización

### Habilitar / Deshabilitar Herramientas (devcontainer.json)

La activación de herramientas se controla ahora desde `devcontainer.json` usando:
- Build args / variables de entorno que consume `post-create.sh`

Ejemplo (fragmento):
```jsonc
{
  "name": "iac-dev",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {},
  "build": {
    "args": {
      "ENABLE_TERRAGRUNT": "true"
    }
  },
  "postCreateCommand": ".devcontainer/script/post-create.sh"
}
```

Desactivar una herramienta: cambia un flag (por ejemplo `ENABLE_TERRAGRUNT=false`).

### Variables de Versiones (si usa script)

En `post-create.sh`:
```bash
version_terragrunt=0.77.17
```

### Agregar Nueva Herramienta

1. Si no existe, añadir lógica al script:
   ```bash
   function installMiHerramienta() {
       # instalación
   }
   installMiHerramienta
   ```
2. (Opcional) Controlar con variable:
   ```bash
   if [ "${ENABLE_MI_HERRAMIENTA}" = "true" ]; then installMiHerramienta; fi
   ```

### Flags Recomendados

Defínelos en `devcontainer.json -> build.args` o `containerEnv`:
- ENABLE_TERRAGRUNT=true|false
- ENABLE_AWS=true|false
- ENABLE_EXTRA_TOOLS=true|false

## 📊 Verificación Post-Instalación

```
----------------------------------------
Resumen de instalación:
✔ Azure CLI disponible
✔ Kubectl disponible
✔ Helm disponible
✔ Terraform disponible
✔ Terragrunt instalado (flag ENABLE_TERRAGRUNT=true)
----------------------------------------
Versiones:
Terraform: v1.5.1
Terragrunt: v0.77.17
Kubectl: v1.28.x
Helm: v3.12.x
Azure CLI: 2.50.0
```

## 🎯 Casos de Uso

- Proyectos IaC
- Entornos multi-cloud
- Gestión Kubernetes
- Onboarding rápido
- CI/CD reproducible
- Laboratorio de aprendizaje

## 🤝 Contribuciones

1. Fork  
2. Rama:
   ```bash
   git checkout -b feature/nueva-herramienta
   ```
3. Commit:
   ```bash
   git commit -m "feat: agregar nueva herramienta"
   ```
4. Push / PR

## 📝 Licencia

MIT. Ver [LICENSE](LICENSE).

## 👤 Autor

- **jblanco33** - *Desarrollo inicial* - [GitHub](https://github.com/jblanco33)

## 🙏 Agradecimientos

- VS Code Dev Containers
- Terraform / Terragrunt
- Kubernetes community

---

<div align="center">

**¿Te gusta este template? ¡Dale una ⭐ star!**

[Reportar Bug](https://github.com/tu-usuario/devContainer-template/issues)
</div>