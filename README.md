Пишем скрипт на bash

Легенда задания
Вам нужно написать скрипт на bash, который на вход принимает два параметра - две директории (входная директория и выходная директория). Во входной директории могут находиться как файлы, так и вложенные директории (внутри которых тоже могут быть как файлы, так и папки) - уровень вложенности может быть любой. Задача скрипта - "обойти" входную директорию и скопировать все файлы из нее (и из всех сложенных директорий) в выходную директорию - но уже без иерархии, а просто все файлы - внутри выходной директории.

Пример:

Входная директория = /home/input_dir; Выходная директория = /home/output_dir.

/home/output_dir изначально пустая.

Структура /home/input_dir:

input_dir
a.txt
dir2
b.txt
dir3
c.txt
Тогда после работы вашего скрипта структура /home/output_dir должна быть следующая:

output_dir
a.txt
b.txt
c.txt
Обратите внимание: в разных поддиректориях входной директории могут быть файлы с одинаковым названием. В момент копирования в выходную аудиторию необходимо такие ситуации каким-либо образом разрешить без потери файлов и содержания файлов (как именно - на ваше усмотрение).

Чтобы запустить скрипт:

1. Откройте терминал.
2. Сделайте скрипт исполняемым:
   
   chmod +x /путь/к/скрипту.sh
   
3. Запустите скрипт:
   
   /путь/к/скрипту.sh /путь/к/исходной/директории /путь/к/выходной/директории
   
Замените /путь/... на реальные пути к файлам и директориям.

Анализ работы:
Мой сценарий написан для копирования содержимого одной директории в другую, с учетом скрытых файлов, но существует пара особенностей и улучшений, которые помогут точнее понять и оптимизировать процесс:

Причины, по которым могут не учитываться скрытые файлы:
1. Использование шаблона * и .*: В коде  используются образцы "${1}"/* и "${1}"/.* для перечисления файлов, включая скрытые. Однако, этот подход иногда может вести к нежелательным поведениям:
   - На некоторых системах или конкретных настройках оболочки может не происходить расширение .* до скрытых файлов по разным причинам, например из-за настроек glob.
   - В bash звездочка * по умолчанию не раскрывает файлы, начинающиеся с точки (скрытые файлы). Так что использование .* необходимо, но оно также включает указатели на текущую (.) и родительскую (..) директории, которые вы правильно исключаете.

Почему перезапись файлов не происходит:
1. Формирование уникального имени файла: скрипт ведет поиск свободного имени для нового файла, добавляя к базовому имени суффикс в форме нижнего подчеркивания и индекса (${base}_${i}${ext}), пока не будет найдено имя, которое ещё не занято. Это предотвращает случайную перезапись файлов при наличии файлов с одинаковыми именами. Подход обеспечивает то, что ни один из оригинальных файлов не будет перезаписан или утрачен по ошибке.

Возможные улучшения:
- Использование find вместо ручного перебора: 
Использование команды find может облегчить обработку файлов и предоставить более гибкие настройки для обработки скрытых файлов и директорий.
- Предотвращение бесконечных рекурсий: 
В коде есть условие проверки, является ли элемент директорией, что хорошо, но можно также добавить проверку на символические ссылки, которые могут создавать циклические ссылки.
