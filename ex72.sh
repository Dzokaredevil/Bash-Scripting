#!/bin/bash

# Модификация примера "ex72.sh", добавлено шифрование пароля.

# в сеть пароль уходит в незашифрованном виде.
# Используйте "ssh", если вас это беспокоит.

E_BADARGS=65

if [ -z "$1" ]
then
  echo "Порядок использования: `basename $0` имя_файла"
  exit $E_BADARGS
fi

Username=dvoytovich           # Измените на свой.
pword=/home/dvoytovich/secret/password_encrypted.file
# Файл, содержащий пароль в зашифрованном виде.

Filename=`basename $1`  # Удалить путь из имени файла

Server="XXX"
Directory="YYY"         # Подставьте фактические имя сервера и каталога.


Password=`cruft <$pword`          # Расшифровка.
#  Используется авторская программа "cruft",
#+ основанная на алгоритме "onetime pad",
#+ ее можно скачать с :
#+ Primary-site:   ftp://ibiblio.org/pub/Linux/utils/file
#+                 cruft-0.2.tar.gz [16k]


ftp -n $Server <<End-Of-Session
user $Username $Password
binary
bell
cd $Directory
put $Filename
bye
End-Of-Session
# ключ -n, команды "ftp", запрещает автоматический вход.
# "bell" -- звонок (звуковой сигнал) после передачи каждого файла.

exit 0
