#!/bin/bash
# days-between.sh:    Подсчет числа дней между двумя датами.
# Порядок использования: ./days-between.sh [M]M/[D]D/YYYY [M]M/[D]D/YYYY

ARGS=2                # Ожидается два аргумента из командной строки.
E_PARAM_ERR=65        # Ошибка в числе ожидаемых аргументов.

REFYR=1600            # Начальный год.
CENTURY=100
DIY=365
ADJ_DIY=367           # Корректировка на високосный год + 1.
MIY=12
DIM=31
LEAPCYCLE=4

MAXRETVAL=255         # Максимально возможное возвращаемое значение
                      # для положительных чисел.

diff=                         # Количество дней между датами.
value=                # Абсолютное значение.
day=                  # день, месяц, год.
month=
year=


Param_Error ()        # Ошибка в параметрах командной строки.
{
  echo "Порядок использования: `basename $0` [M]M/[D]D/YYYY [M]M/[D]D/YYYY"
  echo "       (даты должны быть после 1/3/1600)"
  exit $E_PARAM_ERR
}


Parse_Date ()                 # Разбор даты.
{
  month=${1%%/**}
  dm=${1%/**}                 # День и месяц.
  day=${dm#*/}
  let "year = `basename $1`"  # Хотя это и не имя файла, но результат тот же.
}


check_date ()                 # Проверка даты.
{
  [ "$day" -gt "$DIM" ] || [ "$month" -gt "$MIY" ] || [ "$year" -lt "$REFYR" ] && Param_Error
  # Выход из сценария при обнаружении ошибки.
  # Используется комбинация "ИЛИ-списка / И-списка".
  #
  # Упражнение: Реализуйте более строгую проверку даты.
}


strip_leading_zero () # Удалить ведущий ноль
{
  val=${1#0}          # иначе Bash будет считать числа
  return $val         # восьмеричными (POSIX.2, sect 2.9.2.1).
}


day_index ()          # Формула Гаусса:
{                     # Количество дней от 3 Янв. 1600 до заданной даты.

  day=$1
  month=$2
  year=$3

  let "month = $month - 2"
  if [ "$month" -le 0 ]
  then
    let "month += 12"
    let "year -= 1"
  fi

  let "year -= $REFYR"
  let "indexyr = $year / $CENTURY"


  let "Days = $DIY*$year + $year/$LEAPCYCLE - $indexyr + $indexyr/$LEAPCYCLE + $ADJ_DIY*$month/$MIY + $day - $DIM"


  if [ "$Days" -gt "$MAXRETVAL" ]  # Если больше 255,
  then                             # то поменять знак
    let "dindex = 0 - $Days"       # чтобы функция смогла вернуть полное значение.
  else let "dindex = $Days"
  fi

  return $dindex

}


calculate_difference ()            # Разница между двумя датами.
{
  let "diff = $1 - $2"             # Глобальная переменная.
}


abs ()                             # Абсолютное значение
{                                  # Используется глобальная переменная "value".
  if [ "$1" -lt 0 ]                # Если число отрицательное
  then                             # то
    let "value = 0 - $1"           # изменить знак,
  else                             # иначе
    let "value = $1"               # оставить как есть.
  fi
}



if [ $# -ne "$ARGS" ]              # Требуется два аргумента командной строки.
then
  Param_Error
fi

Parse_Date $1
check_date $day $month $year      # Проверка даты.

strip_leading_zero $day           # Удалить ведущие нули
day=$?                            # в номере дня и/или месяца.
strip_leading_zero $month
month=$?

day_index $day $month $year
date1=$?

abs $date1                         # Абсолютное значение
date1=$value

Parse_Date $2
check_date $day $month $year

strip_leading_zero $day
day=$?
strip_leading_zero $month
month=$?

day_index $day $month $year
date2=$?

abs $date2                         # Абсолютное значение
date2=$value

calculate_difference $date1 $date2

abs $diff                          # Абсолютное значение
diff=$value

echo $diff

exit 0

