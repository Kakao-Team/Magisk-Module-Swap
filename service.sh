#!/system/bin/sh

MODDIR=${0%/*}

# Пути к файлам конфигурации
SWAP_SIZE_FILE="$MODDIR/swap_size.conf"
SWAPPINESS_FILE="$MODDIR/swappiness.conf"
SWAP_PATH="/data/swapfile"

# Функция для логирования
log_message() {
  local message="$1"
  local log_file="/sdcard/MagiskSwapModule/swap_module.log"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> $log_file
}

log_message "Запуск службы создания swap-файла."

# Чтение конфигураций
SWAP_SIZE_MB=$(cat $SWAP_SIZE_FILE)
SWAPPINESS=$(cat $SWAPPINESS_FILE)

# Функция для создания swap-файла
create_swap() {
  if [ ! -f $SWAP_PATH ]; then
    log_message "Создание swap-файла размером $SWAP_SIZE_MB MB."
    dd if=/dev/zero of=$SWAP_PATH bs=1M count=$SWAP_SIZE_MB
    mkswap $SWAP_PATH
  fi

  swapon $SWAP_PATH
  log_message "Swap-файл $SWAP_PATH активирован."
  echo $SWAPPINESS > /proc/sys/vm/swappiness
  log_message "Значение swappiness установлено на $SWAPPINESS."
}

# Вызов функции создания swap-файла
create_swap
log_message "Служба создания swap-файла завершена."
