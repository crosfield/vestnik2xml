# vestnik2xml

`vestnik2xml` - это скрипт на Python, предназначенный для преобразования файлов LaTeX в формат XML, совместимый с elibrary.ru. Инструмент специально адаптирован для журнала "Экологический вестник научных центров Черноморского экономического сотрудничества".

## Версия

Текущая версия программы - 0.4.1.

## Требования

- Python
- pylatexenc
- pdfplumber
- lxml

## Использование

Программа может быть запущена из командной строки с использованием следующего синтаксиса:

```bash
python vestnik2xml [-v] [filename]
```

Где:

- `filename` - это имя файла LaTeX, который нужно преобразовать. Расширение `.tex` является необязательным.
- `-v` или `--verbose` - это необязательный аргумент, который при включении предоставляет подробный вывод.

## Функциональность

Программа выполняет следующие задачи:

- Разбирает файлы LaTeX и извлекает соответствующие метаданные.
- Преобразует текст LaTeX в обычный текст, обрабатывая специальные команды LaTeX и математический режим.
- Обрабатывает информацию об авторах, ключевые слова и библиографию.
- Генерирует XML-файл с извлеченной и обработанной информацией, следуя структуре, требуемой elibrary.ru.

## Вывод

Выводом является XML-файл с тем же именем, что и входной файл LaTeX. Если используется опция `--verbose`, программа также выведет подробные метаданные для каждого обработанного файла.

## Проверка

Программа также проверяет сгенерированный XML по схеме `journal.xsd`. Если XML не проходит проверку, программа выведет ошибки проверки.

## Компиляция

Компиляция для платформы
```pyinstaller --onefile vestnik2xml.py```

## Примечание

Этот инструмент специально разработан для журнала "Экологический вестник научных центров Черноморского экономического сотрудничества" и может некорректно работать с другими документами LaTeX.
