#!/bin/bash

# Убедимся, что скрипт запущен от root
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами root (sudo)."
  exit 1
fi

# Обновляем пакеты системы
echo "Обновление пакетов системы..."
apt-get update -y
apt-get upgrade -y

# Устанавливаем зависимости для Docker
echo "Установка зависимостей..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Добавляем GPG-ключ Docker
echo "Добавление GPG-ключа Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Добавляем репозиторий Docker
echo "Добавление репозитория Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновляем пакеты после добавления репозитория
echo "Обновление пакетов..."
apt-get update -y

# Устанавливаем Docker
echo "Установка Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io

# Добавляем текущего пользователя в группу docker, чтобы не использовать sudo
echo "Добавление текущего пользователя в группу docker..."
usermod -aG docker $SUDO_USER

# Устанавливаем Docker Compose
echo "Установка Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Проверяем установку Docker и Docker Compose
echo "Проверка установки Docker..."
docker --version
echo "Проверка установки Docker Compose..."
docker-compose --version

echo "Установка завершена. Перезагрузите систему или выйдите и войдите снова, чтобы изменения вступили в силу."
