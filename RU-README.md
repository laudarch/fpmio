#Документация к библиотеке io.asm
Простая библиотека ввода-вывода для MASM с возможностью работы на виртуальной машине.
Протестировано на VirtualBox с установленной Windows XP в среде RadASM.

*Данная версия является обновлением для [файлов репозитория](https://github.com/KubSU/SIOMASM).*

***Для обновления скачайте [архив](https://github.com/fpm2014/fpmio/archive/master.zip), распакуйте в любую папку и забустите в ней файл `update.bat`*** В командной строке будет сообщено об удачном копировании файлов. Если произошла ошибка, то скопируйте файл `io.asm` в папку `c:\masm32\include\`. Если окно командной строки моментально закрылось (недостаточно прав доступа) - скопируйте файл `io.asm` в любую папку и пропишите полное имя `io.asm` в проекте.

## Установка IDE RadASM

- Установить MASM из `Install/masm32v11r.zip`. Обязательно в корневой каталог диска `C:\`.
- Установить библиотеку ввода-вывода, запустив от администратора `Install\InstallLibs.bat`.
- Распаковать `Install/RadASM.zip` в любое удобное место на диске `C:\`.

## Использование регистров в IDE RadASM

**Обратите внимание**: при запуске на виртуальной машине некорректно работают регистры. Рекомендуем для решения этой проблемы использовать для индексации по массиву и организации циклов использовать только `32-битные регистры`, в противном случае совместимость и рабротоспособность не гарантируется.

## Пример программы (Hello World!)

```nasm
.686                                ; Архитектура процессора i686
include /masm32/include/io.asm      ; Включаем библиотеку ввода-вывода

.data                               ; Сегмент данных
    msgHello db "Hello World!", 0   ; Объявляемм строковую переменную

.code                               ; Сегмент кода
start:
    print offset msgHello          ; Выводим сообщение
    print                           ; Ждем нажатия любой клавиши
    exit                            ; Завершаем работу программы
end start                           ; Объявлвем точку входа в программу
```

## Макросы
*Квадратные скобки далее означают, что аргумент может отсутствовать.*
*Под регистрами подразумеваются 4 основных регистра EAX, EBX, ECX, EDX и их части.*

###I.	Макросы для работы со строками и символами
Макрос           | Описание
:----------------:|---------
`print [arg]` | Если `arg` регистр или переменная размером в байт, то макрос выводит символ с кодом, хранящимся в них. Если `arg` первый символ строки, то макрос выводит эту строку. Если `arg` непосредственная строка, то макрос выводит эту строку. Если `arg` отсутствует, то макрос ждёт нажатие любой клавиши. **Особенности:** *Нет необходимости использовать offset. Нельзя выводить пустую строку. Необходимо использовать только двойные кавычки.*
`println [arg]` | Аналогично `print`, но с переходом на новую строку после вывода.
`read arg` | Если `arg` регистр или переменная размером в байт, то макрос считывает в неё код нажатой клавиши. **Особенности:** *Рекомендуется использовать в качестве аргумента регистр, так как тогда обеспечивается ввод по горизонтали. Нельзя использовать регистры или переменные размером больше, чем байт.*
`readln arg` | Аналогично `read`, но с переходом на новую строку после ввода.

###II.	Макросы для работы с целыми числами
Макрос           | Описание
:----------------:|---------
`outint num` | Макрос автоматически определяет макрос для вывода знакового значения в десятичной системе счисления регистра или переменной `num`. **Особенности:** *Для вывода элементов массива используйте макросы `outint8`, `outint16`, `outint32`*
`inint num` | Макрос автоматически определяет макрос для ввода знакового значения в десятичной системе счисления в регистр или переменную `num`. **Особенности:** *Для ввода элементов массива используйте макросы `inint8`, `inint16`, `inint32`*
`outint32 num`, `outint16 num`, `outint8   num` | Макрос выводит знаковое число в десятичной системе из регистра или переменной размерами в 32, 16 и 8 бит соответственно.
`inint32 num`, `inint16 num`, `inint8   num` | Макрос вводит знаковое число в десятичной системе в регистр или переменную размерами в 32, 16 и 8 бит соответственно.

###III.	Макросы старой версии (для совместимости со старыми программами)
Рекомендуем не использовать указанные ниже макросы.

Макрос           | Описание
:----------------:|---------
`inch char` | Аналогичен `read` (переопределён через `read`).
`outch [char]` | Аналогичен `print` (переопределён через `print`).
`inkey [text]` | Выводит непосредственную строку `text`, и ждет нажатия любой клавиши. (скопирован из macro.asm для решения проблемы с порчей регистров). 
`newline` | Переход на новую строку.
`outstr offset str` | Выводит строку `str` используя `offset`.
`outstrln offset str` | Выводит строку `str` используя `offset`, с переводом на новую строку.

## Описание изменений

1. Исправлен баг с выводом макросами `outint8` и `outint16` знаковых чисел.
2. Макросы вывода `outint8`, `outint16`, `outint32` автоматически выбираются при использовании макроса `outint`.
3. Макросы ввода `inint8`, `inint16`, `inint32` автоматически выбираются при использовании макроса `inint`.
4. Введены новые макросы `print` / `println` и `read` / `readln` (подробности в описании выше).
5. Макрос `inch` теперь работает со всеми основными 8 битными регистрами.
6. Макрос `inch` теперь поддерживает ввод по горизонтали.
6. Исправлен баг с вылетом программы для макроса `outch` (переопределён через `print`).
7. Макрос `inkey` больше не портит регистры.