#!/system/bin/sh

# Магическая строка для Magisk
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

# Путь для логирования
LOG_PATH="/data/local/tmp/MagiskSwapModule"
mkdir -p $LOG_PATH

# Функция для логирования
log_message() {
  local message="$1"
  local log_file="$LOG_PATH/swap_module.log"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> $log_file
}

# Настройки по умолчанию
SWAP_SIZE_MB=4096  # Размер swap-файла в мегабайтах (4 ГБ)
SWAPPINESS=60      # Значение swappiness по умолчанию

log_message "Начало установки модуля."

# Создание swap-файла
SWAP_FILE_PATH="/data/swapfile"

log_message "Создание swap-файла размером ${SWAP_SIZE_MB}MB в ${SWAP_FILE_PATH}."

# Создание файла swap
dd if=/dev/zero of=$SWAP_FILE_PATH bs=1M count=$SWAP_SIZE_MB
if [ $? -ne 0 ]; then
  log_message "Ошибка при создании файла swap."
  exit 1
fi

# Форматирование файла как swap
mkswap $SWAP_FILE_PATH
if [ $? -ne 0 ]; then
  log_message "Ошибка при форматировании файла как swap."
  exit 1
fi

# Активирование swap-файла
swapon $SWAP_FILE_PATH
if [ $? -ne 0 ]; then
  log_message "Ошибка при активации swap-файла."
  exit 1
fi

log_message "Swap-файл успешно создан и активирован."

# Установка swappiness
echo $SWAPPINESS > /proc/sys/vm/swappiness
if [ $? -ne 0 ]; then
  log_message "Ошибка при установке значения swappiness."
  exit 1
fi

log_message "Swappiness успешно установлен на $SWAPPINESS."

# Сохранение настроек
echo "$SWAP_SIZE_MB" > /data/local/tmp/swap_size.conf
echo "$SWAPPINESS" > /data/local/tmp/swappiness.conf

log_message "Настройки сохранены. Размер swap-файла: $SWAP_SIZE_MB MB, swappiness: $SWAPPINESS."

# Проверка успешности создания swap
if grep -q $SWAP_FILE_PATH /proc/swaps; then
  log_message "Проверка успешности: swap-файл найден в /proc/swaps."
else
  log_message "Проверка успешности: swap-файл не найден в /proc/swaps."
  exit 1
fi

log_message "Установка модуля завершена успешно."
