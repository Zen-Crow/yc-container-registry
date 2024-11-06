# Yandex Container Registry с использованием Terraform

Этот проект автоматизирует создание **Yandex Container Registry** и **Yandex Container Repository** с помощью Terraform. Также включена автоматическая сборка и пуш Docker-образов в созданный репозиторий.

## Описание

**Yandex Container Registry** — это хранилище для Docker-образов в Yandex Cloud, которое позволяет хранить образы контейнеров, доступные для использования и деплоя. В этом проекте создается **реестр контейнеров** в Yandex Cloud для хранения Docker-образов.

**Yandex Container Repository** — это набор Docker-образов с одинаковыми именами (т.е. версиями образа). Репозитории служат для управления версиями одного образа и позволяют организовать хранилище для разных вариантов одного и того же приложения, например, для разных версий или тегов.


## Установка и настройка проекта

Клонируйте репозиторий:

git clone https://github.com/Zen-Crow/yc-container-registry.git

cd yc-container-registry/


### 1. Установка зависимостей

Для начала вам нужно установить несколько инструментов, которые необходимы для работы проекта.

1. **Terraform**:
   - Скачайте и установите [Terraform](https://www.terraform.io/downloads.html).
   - Убедитесь, что Terraform доступен в вашей системе, проверив его версию командой `terraform --version`.

2. **Docker**:
   - Скачайте и установите [Docker](https://docs.docker.com/get-docker/).
   - Убедитесь, что Docker правильно установлен, проверив его версию командой `docker --version`.

3. **Yandex CLI**:
   - Скачайте и установите [Yandex CLI](https://cloud.yandex.com/docs/cli/quickstart).
   - Пройдите авторизацию в Yandex Cloud с помощью команды `yc init`. Вам понадобятся API-ключи для дальнейшей работы с Terraform.


### 2. Установка переменных окружения

Запустите скрипт для вашей OS в папке env.

команда powershell:

. .\set_env.ps1

команда linux:

chmod +x set_env.sh && ./set_env.sh

### 3. Аутентифицируйтесь в Yandex Container Registry с помощью Docker Credential helper.

yc container registry configure-docker
 

### 4. Отредактируйте Dockerfile для сборки вашего образа в папке config-app

### 5. Укажите имя и тэг образа в файле main.tf 

docker_image_name = "image-name"

tag               = "latest"

### Запуск проекта

    `terraform init` — инициализация Terraform;

    `terraform plan` — просмотр изменений, которые будут применены;

    `terraform apply` — применение изменений.

### Удаление ресурсов

!!! Перед удалением всех ресурсов необходимо удалить образ(ы) из вашего репозитория.

    `terraform destroy`
