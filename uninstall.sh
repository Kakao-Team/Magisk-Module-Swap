#!/system/bin/sh

SWAP_PATH="/data/swapfile"

# Функция для логирования
log_message() {
  local message="$1"
  local log_file="/sdcard/MagiskSwapModule/swap_module.log"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> $log_file
}

log_message "Удаление модуля и swap-файла."

# Проверка и удаление swap-файла
if [ -f $SWAP_PATH ]; then
  swapoff $SWAP_PATH
  rm -f $SWAP_PATH
  log_message "Swap-файл $SWAP_PATH успешно удален."
else
  log_message "Swap-файл не найден, пропускаем удаление."
fi
