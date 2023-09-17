#!/bin/bash

# загрузка конфига
source backup_config.cfg

# проверка наличия каталога для сохранения
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# Створення архіву з каталогів для бекапу
timestamp=$(date +%Y%m%d%H%M%S)
backup_name="backup_$timestamp.tar.gz"
tar -czf "$BACKUP_DIR/$backup_name" $SOURCE_DIRS

# логи
echo "$(date '+%Y-%m-%d %H:%M:%S') - Создано новый бекап: $backup_name" >> "$LOG_FILE"

# проверка количества бекапов
while [ $(ls -t "$BACKUP_DIR" | wc -l) -gt $MAX_BACKUPS ] || [ $(du -hs "$BACKUP_DIR" | awk '{print $1}') -gt $(du -hs "$MAX_BACKUP_SIZE" | awk '{print $1}') ]; do
    oldest_backup=$(ls -t "$BACKUP_DIR" | tail -n 1)
    rm -f "$BACKUP_DIR/$oldest_backup"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Удалено старый бекап: $oldest_backup" >> "$LOG_FILE"
done
