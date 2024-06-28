import sys
import os
import re
import argparse
from pylatexenc.latex2text import LatexNodes2Text
from pylatexenc.latexwalker import LatexCharsNode
from XMLElement import XMLElement
import pdfplumber
import zipfile
from lxml import etree

def parse_command(latex_text, command):
    results = []
    i = 0

    while i < len(latex_text):
        if latex_text[i] == "\\":
            # Если текущая строка - это комментарий, пропускаем ее
            if latex_text[:i].rfind('%') > latex_text[:i].rfind('\n'):
                i += 1
                continue

            start = i + 1
            i += 1
            while i < len(latex_text) and latex_text[i] not in [' ', '{', '[', '*', '\n', '\\']:
                i += 1
            found_command = latex_text[start:i]

            if found_command == command or found_command == command + '*':
                command_args = []
                optional_args = []

                if i < len(latex_text) and latex_text[i] == '*':
                    i += 1

                while i < len(latex_text) and latex_text[i] in [' ', '\n']:
                    i += 1

                while i < len(latex_text) and latex_text[i] in ['{', '[']:
                    if latex_text[i] == '{':
                        i += 1
                        start = i
                        brace_count = 1
                        while i < len(latex_text) and brace_count > 0:
                            if latex_text[i] == '{':
                                brace_count += 1
                            elif latex_text[i] == '}':
                                brace_count -= 1
                            i += 1
                        command_args.append(latex_text[start:i-1])
                    elif latex_text[i] == '[':
                        i += 1
                        start = i
                        while i < len(latex_text) and latex_text[i] != ']':
                            i += 1
                        optional_args.append(latex_text[start:i])
                        i += 1

                results.append(command_args + optional_args)
            else:
                while i < len(latex_text) and latex_text[i] not in [' ', '{', '[', '\\']:
                    i += 1
        else:
            i += 1

    return results

class CustomLatexNodes2Text(LatexNodes2Text):
    def visit_latex_chars_node(self, node):
        # Переопределение поведения для двух одинарных кавычек
        if isinstance(node, LatexCharsNode) and node.chars == "''":
            return "''"
        # Для всех остальных случаев использовать поведение по умолчанию
        return super().visit_latex_chars_node(node)

def get_clean_latex(latex_text):
    # Заменяем _ и ^ на #### и @@@@ в математическом режиме
    outside_math_mode = re.split(r'\$.*?\$|\\\[.*?\\\]|\\begin{.*?}.*?\\end{.*?}', latex_text)
    inside_math_mode = re.findall(r'\$.*?\$|\\\[.*?\\\]|\\begin{.*?}.*?\\end{.*?}', latex_text)
    for i in range(len(inside_math_mode)):
        inside_math_mode[i] = re.sub(r'_(\{.*?\}|(?<=_)\s*\S)', r'####\1####', inside_math_mode[i])
        inside_math_mode[i] = re.sub(r'\^(\{.*?\}|(?<=\^)\s*\S)', r'@@@@\1@@@@', inside_math_mode[i])
    latex_text = ''.join(sum(zip(outside_math_mode, inside_math_mode + ['']), ()))

    # Преобразуем LaTeX в текст
    source_text = CustomLatexNodes2Text().latex_to_text(latex_text)

    # Заменяем < на &lt; и > на &gt;
    source_text = source_text.replace('<<', '"')
    source_text = source_text.replace('>>', '"')
    source_text = source_text.replace('``', '"')
    source_text = source_text.replace("''", '"')
    source_text = source_text.replace('"=', '-')
    source_text = source_text.replace('&', '&amp;')
    source_text = source_text.replace('<', '&lt;')
    source_text = source_text.replace('>', '&gt;')

    # Заменяем #### и @@@@ на <sub></sub> и <sup></sup>
    while '####' in source_text:
        source_text = source_text.replace('####', '<sub>', 1)
        source_text = source_text.replace('####', '</sub>', 1)
    while '@@@@' in source_text:
        source_text = source_text.replace('@@@@', '<sup>', 1)
        source_text = source_text.replace('@@@@', '</sup>', 1)

    result = source_text.replace('\u00A0', ' ')
    result = re.sub(r'(?<!\n)\n(?!\n)', ' ', result)  # Замена одиночных переводов строк на пробел
    result = re.sub(r'\n{2,}', '\n', result)  # Замена двух и более подряд идущих символов перевода строки на один
    result = re.sub(r'\n', ' ', result)
    result = re.sub(r'\s{2,}', ' ', result)
    result = result.strip()
    return result

def get_clean_bibliography(latex_text):
    # Заменяем _ и ^ на #### и @@@@ в математическом режиме
    outside_math_mode = re.split(r'\$.*?\$|\\\[.*?\\\]|\\begin{.*?}.*?\\end{.*?}', latex_text)
    inside_math_mode = re.findall(r'\$.*?\$|\\\[.*?\\\]|\\begin{.*?}.*?\\end{.*?}', latex_text)
    for i in range(len(inside_math_mode)):
        inside_math_mode[i] = re.sub(r'_(\{.*?\}|(?<=_)\s*\S)', r'####\1####', inside_math_mode[i])
        inside_math_mode[i] = re.sub(r'\^(\{.*?\}|(?<=\^)\s*\S)', r'@@@@\1@@@@', inside_math_mode[i])
    latex_text = ''.join(sum(zip(outside_math_mode, inside_math_mode + ['']), ()))

    # Преобразуем LaTeX в текст
    source_text = CustomLatexNodes2Text().latex_to_text(latex_text)

    # Заменяем < на &lt; и > на &gt;
    source_text = source_text.replace('&', '&amp;')
    source_text = source_text.replace('<', '&lt;')
    source_text = source_text.replace('>', '&gt;')
    source_text = source_text.replace('"=', '-')
    source_text = source_text.replace('\\,', '')

    # Заменяем #### и @@@@ на <sub></sub> и <sup></sup>
    while '####' in source_text:
        source_text = source_text.replace('####', '<sub>', 1)
        source_text = source_text.replace('####', '</sub>', 1)
    while '@@@@' in source_text:
        source_text = source_text.replace('@@@@', '<sup>', 1)
        source_text = source_text.replace('@@@@', '</sup>', 1)

    # source_text = source_text.replace('&', '&amp;')
    source_text = source_text.replace('<<', '"').replace('>>', '"').replace('``', '"').replace("''", '"')

    result = source_text.replace('\u00A0', ' ')
    result = re.sub(r'(?<!\n)\n(?!\n)', ' ', result)  # Замена одиночных переводов строк на пробел
    result = re.sub(r'\n{2,}', '\n', result)  # Замена двух и более подряд идущих символов перевода строки на один
    result = re.sub(r'\n', ' ', result)
    result = re.sub(r'\s{2,}', ' ', result)
    result = result.strip()
    return result

def convert_to_ranges(numbers):
    if not numbers:
        return ""

    numbers.sort()
    ranges = [[numbers[0]]]

    for num in numbers[1:]:
        if num == ranges[-1][-1] + 1:
            ranges[-1].append(num)
        else:
            ranges.append([num])

    range_strings = []
    for r in ranges:
        if len(r) == 1:
            range_strings.append(str(r[0]))
        else:
            range_strings.append(f"{r[0]}-{r[-1]}")

    return ",".join(range_strings)

def get_clean_article(latex_text, filename):
    latex_text  = re.sub(r'(?<!\\)%.*', '', latex_text)  # Удаляем комментарии
    # Ищем начало основного текста статьи, учитывая возможный необязательный аргумент у \maketitle
    start_index = re.search(r'\\maketitle(\[.*?\])?', latex_text).end()
    end_index = latex_text.find("\\begin{thebibliography}")
    if start_index == -1 or end_index == -1:
        print("Не удалось найти основной текст статьи")
        return
    article_text = latex_text[start_index:end_index]

    # Удаляем цифры после \begin{subfigure}{
    article_text = re.sub(r'(\\begin{subfigure}{).+(})', r'\1\2', article_text)

    # Заменяем <<, >>, `` и '' на " вне математического режима
    outside_math_mode = re.split(r'\$.*?\$|\\\[.*?\\\]|\\begin{.*?}.*?\\end{.*?}', article_text)
    inside_math_mode = re.findall(r'\$.*?\$|\\\[.*?\\\]|\\begin{.*?}.*?\\end{.*?}', article_text)
    for i in range(len(outside_math_mode)):
        outside_math_mode[i] = outside_math_mode[i].replace('<<', '"').replace('>>', '"').replace('``', '"').replace("''", '"')
    article_text = ''.join(sum(zip(outside_math_mode, inside_math_mode + ['']), ()))

    # Читаем содержимое файла .aux
    aux_filename = filename + '.aux'
    with open(aux_filename, 'r') as file:
        aux_text = file.read()

    # Обрабатываем каждую команду \cite
    for cite in re.findall(r'\\cite(\[.*?\])?{(.*?)}', article_text):
        optional_arg = cite[0]
        mandatory_arg = cite[1]
        new_cite = ''
        for arg in mandatory_arg.split(','):
            bibcite = re.search(r'\\bibcite\{' + arg + r'\}\{(.*?)\}', aux_text)
            if bibcite:
                new_cite += bibcite.group(1) + ','
        new_cite = new_cite[:-1]  # Удаляем последнюю запятую и добавляем закрывающую скобку
        numbers = list(map(int, re.findall(r'\d+', new_cite)))
        new_cite = convert_to_ranges(numbers)
        new_cite = str(new_cite)
        if optional_arg:
            new_cite += optional_arg
        article_text = article_text.replace('\\cite' + cite[0] + r'{' + cite[1] + r'}', '[' + new_cite + ']')

    # Обрабатываем каждую команду \ref и \eqref
    for command in ['ref', 'eqref']:
        for ref in re.findall(r'\\' + command + r'{(.*?)}', article_text):
            newlabel = re.search(r'\\newlabel{' + ref + r'}{{(.*?)}', aux_text)
            if newlabel:
                new_ref = newlabel.group(1).split('}')[0]  # Берем только первую часть до закрывающей скобки
                if command == 'eqref':
                    new_ref = '(' + new_ref + ')'
                # Если в newlabel есть команда, начинающаяся с \cyr, добавляем пробел после new_ref
                if '\\cyr' in newlabel.group(1):
                    new_ref = '{' + new_ref + '}'
                article_text = article_text.replace('\\' + command + '{' + ref + '}', new_ref)

    # Заменяем команды \section на последовательные цифры, начиная с 1
    section_counter = 1
    while '\\section{' in article_text:
        article_text = article_text.replace('\\section{', '\n' + str(section_counter) + '. ', 1)
        section_counter += 1

    # Удаляем команды \section*
    article_text = article_text.replace('\\section*{', '\n')

    # Очищаем текст от LaTeX команд
    source_text = CustomLatexNodes2Text().latex_to_text(article_text)

    source_text = source_text.replace('< g r a p h i c s >', '')  # Удаление всех вхождений < g r a p h i c s >

    # Заменяем < на &lt; и > на &gt;
    source_text = source_text.replace('&', '&amp;')
    source_text = source_text.replace('<', '&lt;')
    source_text = source_text.replace('>', '&gt;')
    source_text = source_text.replace('"=', '-')

    result = source_text.replace('\u00A0', ' ')
    result = re.sub(r'(?<!\n)\n(?!\n)', ' ', result)  # Замена одиночных переводов строк на пробел
    result = re.sub(r'\n{2,}', '\n', result)  # Замена двух и более подряд идущих символов перевода строки на один

    result = result.strip()
    return result

def process_authors(results):
    for author_key, affil_key in [('authorrus', 'affilrus'), ('authoreng', 'affileng'), ('reviewer', 'affilrev')]:
        changed_key = author_key + '_changed'
        results[changed_key] = []
        for author in results[author_key]:
            new_author = author[:2]
            if len(author) > 2:
                if re.match(r'^\d+(,\d+)*$', author[2]):
                    affiliations = author[2].split(',')
                    new_affiliations = []
                    for affil in affiliations:
                        for affil_item in results[affil_key]:
                            if affil_item[1] == affil:
                                orgname_content = parse_command(affil_item[0], 'orgname')
                                city_content = parse_command(affil_item[0], 'city')
                                country_content = parse_command(affil_item[0], 'country')
                                if orgname_content:
                                    new_affiliations.append(orgname_content[0][0])
                    new_author.append(';'.join(new_affiliations))
                    if city_content:
                        new_author.append(city_content[0][0])
                    if country_content:
                        new_author.append(country_content[0][0])
            else:
                for affil_item in results[affil_key]:
                    orgname_content = parse_command(affil_item[0], 'orgname')
                    city_content = parse_command(affil_item[0], 'city')
                    country_content = parse_command(affil_item[0], 'country')
                    if orgname_content:
                        new_author.append(orgname_content[0][0])
                    if city_content:
                        new_author.append(city_content[0][0])
                    if country_content:
                        new_author.append(country_content[0][0])
            results[changed_key].append(new_author)
    return results

def parse_bibliography(text):
    bibliography = []

    # Ищем текст между \begin{thebibliography} и \end{thebibliography}
    bib_text = re.search(r'\\begin{thebibliography}(.*?)\\end{thebibliography}', text, re.DOTALL)

    if bib_text:
        # Удаляем комментарии
        bib_text = re.sub(r'%.*$', '', bib_text.group(0), flags=re.MULTILINE)

        # Разделяем текст на отдельные источники
        sources = re.split(r'\\bibitem{(.*?)}', bib_text)[1:]

        # Обрабатываем каждый источник
        for i in range(0, len(sources), 2):

            # Удаляем команду \altbib и ее содержимое
            source_text = re.sub(r'\\altbib{(?:[^{}]|{[^{}]*})*}', '', sources[i + 1])

            # Заменяем команды \doi и \edn на DOI и EDN соответственно
            source_text = re.sub(r'\\doi{(.*?)}', r'DOI: \1', source_text)
            source_text = re.sub(r'\\edn{(.*?)}', r'EDN: \1', source_text)
            source_text = re.sub(r'\\No', r'№', source_text)

            source_text = source_text.replace('<<', '"')
            source_text = source_text.replace('>>', '"')
            source_text = source_text.replace('``', '"')
            source_text = source_text.replace("''", '"')

            source_text = get_clean_bibliography(source_text)

            # Очищаем текст от UNICODE-символов типа неразрывного пробела
            source_text = source_text.replace('\u00A0', ' ')

            # Добавляем результат в массив
            bibliography.append([sources[i], source_text.strip()])

    return bibliography


def parse_and_save_results(content, filename):
    commands = ["udc", "OJS", "EDN", "rubric",
                "titlerus", "titleeng",
                "annotationrus", "annotationeng",
                "keywordsrus", "keywordseng",
                "fundingrus", "fundingeng",
                "affilrus", "affileng",
                "reviewer", "inforev", "affilrev",
                "emailrev", "review",
                "date", "revised", "accepted"
                ]

    author_commands = ["authorrus", "authoreng",
                       "inforus", "infoeng",
                       "email", "orcid", "spin"
                       ]

    rubric_translation = {
        "Механика": "Mechanics",
        "Физика": "Physics",
        "Математика": "Mathematics"
    }

    results = {}
    for command in commands:
        results[command] = parse_command(content, command)

    # Проверяем, что в результате есть ключ 'rubric'
    if 'rubric' in results:
        # Переименовываем ключ 'rubric' в 'rubricrus'
        results['rubricrus'] = results.pop('rubric')
        # Получаем английское название рубрики из словаря rubric_translation
        rubric_eng = rubric_translation.get(results['rubricrus'][0][0])
        # Добавляем английское название рубрики в результаты
        results['rubriceng'] = [[rubric_eng]] if rubric_eng else [[""]]

    # Разделяем исходный текст на блоки для каждого автора
    author_blocks = re.split(r'(?=\\authorrus)', content)[
                    1:]  # Игнорируем первый блок, так как он не относится к автору

    # Обработка авторов
    for block in author_blocks:
        for command in author_commands:
            parsed_command = parse_command(block, command)
            if parsed_command:
                if command in results:
                    results[command].append(parsed_command[0])
                else:
                    results[command] = [parsed_command[0]]
            else:
                if command in results:
                    results[command].append("")
                else:
                    results[command] = [""]

    # Обработка ключевых слов
    for keyword_key in ['keywordsrus', 'keywordseng']:
        if results[keyword_key]:
            temp_keywords = results[keyword_key][0][0]
            results[keyword_key] = [[keyword.strip() for keyword in temp_keywords.split(',')]]
    results['article'] = [get_clean_article(content, filename)]
    results['bibliography'] = parse_bibliography(content)
    print("Обработан файл " + filename + ".tex")
    return results

def get_page_numbers(filename):
    # Заменяем расширение файла на .ref и .aux
    ref_filename = filename + '.ref'
    aux_filename = filename + '.aux'

    # Проверяем, что файлы существуют
    if not os.path.isfile(ref_filename) or not os.path.isfile(aux_filename):
        print(f"Файлы {ref_filename} или {aux_filename} не найдены")
        return None, None

    # Читаем содержимое файлов
    with open(ref_filename, 'r') as file:
        ref_content = file.read()
    with open(aux_filename, 'r') as file:
        aux_content = file.read()

    # Извлекаем номера страниц
    first_page = parse_command(ref_content, 'FirstPage')[0][0] if parse_command(ref_content, 'FirstPage') else None
    last_page = parse_command(aux_content, 'lastpage@lastpage')[0][0] if parse_command(aux_content, 'lastpage@lastpage') else None

    return first_page, last_page

def replace_date(iso_date):
    return iso_date.replace('-', '.')

def process_files(file_list):
    metadata = {}
    for filename in file_list:
        with open(filename + '.tex', 'r') as file:
            latex_text = file.read()
        metadata[filename] = parse_and_save_results(latex_text, filename)

        # Обработка данных об авторах
        metadata[filename] = process_authors(metadata[filename])

    return metadata

def merge_files(file_list, output_filename, metadatas):
    journal = XMLElement("journal")
    # Добавляем дочерние элементы в корневой элемент
    journal.add_child(XMLElement("titleid", text="9261"))
    journal.add_child(XMLElement("issn", text="1729-5459"))
    journal.add_child(XMLElement("eissn"))

    journalInfo = XMLElement("journalInfo", attributes={"lang": "RUS"})
    journalInfo.add_child(XMLElement("title", text="Экологический вестник научных центров Черноморского экономического сотрудничества"))
    journal.add_child(journalInfo)

    issue = XMLElement("issue")
    issue.add_child(XMLElement("volume", text=VOLUME))
    issue.add_child(XMLElement("number", text=ISSUE))
    issue.add_child(XMLElement("dateUni", text=YEAR))
    # Открываем PDF-файл
    with pdfplumber.open(output_filename + '.pdf') as pdf:
        # Получаем общее число страниц
        total_pages = len(pdf.pages)

    # Создаем элемент "pages" с общим числом страниц
    issue.add_child(XMLElement("pages", text=f"1-{total_pages}"))
    issue.add_child(XMLElement("issTitle"))

    articles = XMLElement("articles")

    # Добавляем содержимое каждого файла в элемент articles
    for filename in file_list:
        articles.add_comment(filename)
        metadata = metadatas[filename]

        # Создаем элемент article для каждого файла
        article = create_article_element(articles,metadata,filename)

        # Добавляем элемент article в элемент articles
        articles.add_child(article)

    # Добавляем элемент articles в элемент issue
    issue.add_child(articles)

    # Добавляем элемент issue в корневой элемент
    journal.add_child(issue)

    return journal

def create_xml_element(parent, name, attributes, metadata, key, text_index=0, text_index_inner=None):
    try:
        element = XMLElement(name, attributes=attributes)
        if metadata[key]:  # Проверяем, что список не пуст
            if text_index_inner is not None:
                element.text = get_clean_latex(metadata[key][text_index][text_index_inner])
            else:
                if key == 'revised':
                    element.text = replace_date(metadata[key][text_index][0])
                else:
                    element.text = get_clean_latex(metadata[key][text_index][0])
        parent.add_child(element)
    except KeyError as e:
        print(f"Отсутствует поле для записи {name}")
    except Exception as e:
        print(f"Произошла ошибка {e} при записи {name}")

def create_article_element(articles, metadata, filename):

    # Создаем секцию
    section = XMLElement("section")

    create_xml_element(section, "secTitle", {"lang": "RUS"}, metadata, 'rubricrus')
    create_xml_element(section, "secTitle", {"lang": "ENG"}, metadata, 'rubriceng')

    # Добавляем секцию в элемент articles
    articles.add_child(section)

    # Создаем элемент article
    article = XMLElement("article")

    # Создаем элемент pages и записываем диапазон страниц
    pages = XMLElement("pages")
    first_page, last_page = get_page_numbers(filename)
    if first_page and last_page:
        pages_text = first_page + "-" + last_page
        metadata['pages'] = [[pages_text]]
        create_xml_element(article, "pages", {}, metadata, 'pages')

    # Добавляем элемент pages в элемент article
    article.add_child(pages)

    # Создаем элемент artType и устанавливаем его в RAR
    artType = XMLElement("artType")
    artType.text = "RAR"
    article.add_child(artType)

    # Создаем элемент authors для авторов
    authors = XMLElement("authors")

    # Создаем элемент author для каждого автора
    for i, author in enumerate(metadata.get('authorrus_changed', []), start=1):
        author = XMLElement("author", {"num": str(i)})  # Передаем порядковый номер автора

        authorCodes = XMLElement("authorCodes")
        if 'orcid' in metadata and i <= len(metadata['orcid']) and metadata['orcid'][i - 1]:
            create_xml_element(authorCodes, "orcid", {}, metadata, 'orcid', i - 1)
        if 'spin' in metadata and i <= len(metadata['spin']) and metadata['spin'][i - 1]:
            create_xml_element(authorCodes, "spin", {}, metadata, 'spin', i - 1)
        author.add_child(authorCodes)

        individInfo_rus = XMLElement("individInfo", {"lang": "RUS"})
        # Создаем элементы для ФИО автора
        create_xml_element(individInfo_rus, "surname", {}, metadata, 'authorrus_changed', i-1, 0)
        create_xml_element(individInfo_rus, "initials", {}, metadata, 'authorrus_changed', i-1, 1)
        create_xml_element(individInfo_rus, "orgName", {}, metadata, 'authorrus_changed', i-1, 2)
        metadata['cityrus_text'] = [[get_clean_latex(metadata['authorrus_changed'][i-1][3] + ', ' + metadata['authorrus_changed'][i-1][4])]]
        create_xml_element(individInfo_rus, "address", {}, metadata, 'cityrus_text')
        create_xml_element(individInfo_rus, "town", {}, metadata, 'authorrus_changed', i - 1, 3)
        create_xml_element(individInfo_rus, "country", {}, metadata, 'authorrus_changed', i - 1, 4)
        create_xml_element(individInfo_rus, "email", {}, metadata, 'email', i-1)
        create_xml_element(individInfo_rus, "otherInfo", {}, metadata, 'inforus', i-1, 0)
        author.add_child(individInfo_rus)

        individInfo_eng = XMLElement("individInfo", {"lang": "ENG"})
        # Создаем элементы для ФИО автора
        create_xml_element(individInfo_eng, "surname", {}, metadata, 'authoreng_changed', i - 1, 0)
        create_xml_element(individInfo_eng, "initials", {}, metadata, 'authoreng_changed', i - 1, 1)
        create_xml_element(individInfo_eng, "orgName", {}, metadata, 'authoreng_changed', i - 1, 2)
        metadata['cityeng_text'] = [
            [get_clean_latex(metadata['authoreng_changed'][i - 1][3] + ', ' + metadata['authoreng_changed'][i - 1][4])]]
        create_xml_element(individInfo_eng, "address", {}, metadata, 'cityeng_text')
        create_xml_element(individInfo_eng, "town", {}, metadata, 'authoreng_changed', i - 1, 3)
        create_xml_element(individInfo_eng, "country", {}, metadata, 'authoreng_changed', i - 1, 4)
        author.add_child(individInfo_eng)

        # Добавляем элемент author в authors
        authors.add_child(author)

    # Создаем элемент reviewer для рецензента, если он есть
    if 'reviewer_changed' in metadata and metadata['reviewer_changed']:
        reviewer = XMLElement("author", {"num": str(i + 1)})  # Передаем порядковый номер рецензента

        role = XMLElement("role")
        role.text = "23"
        reviewer.add_child(role)

        individInfo_rev = XMLElement("individInfo", {"lang": "RUS"})
        # Создаем элементы для ФИО автора
        create_xml_element(individInfo_rev, "surname", {}, metadata, 'reviewer_changed', 0, 0)
        create_xml_element(individInfo_rev, "initials", {}, metadata, 'reviewer_changed', 0, 1)
        create_xml_element(individInfo_rev, "orgName", {}, metadata, 'reviewer_changed', 0, 2)
        metadata['cityrev_text'] = [[get_clean_latex(metadata['reviewer_changed'][0][3] + ', ' + metadata['reviewer_changed'][0][4])]]
        create_xml_element(individInfo_rev, "address", {}, metadata, 'cityrev_text')
        create_xml_element(individInfo_rev, "town", {}, metadata, 'reviewer_changed', 0, 3)
        create_xml_element(individInfo_rev, "country", {}, metadata, 'reviewer_changed', 0, 4)
        create_xml_element(individInfo_rev, "email", {}, metadata, 'emailrev', 0)
        create_xml_element(individInfo_rev, "otherInfo", {}, metadata, 'inforev', 0, 0)
        create_xml_element(individInfo_rev, "comment", {}, metadata, 'review')
        create_xml_element(individInfo_rev, "commentDate", {}, metadata, 'revised')

        reviewer.add_child(individInfo_rev)

        authors.add_child(reviewer)

    # Добавляем элемент authors в article
    article.add_child(authors)

    # Создаем элементы artTitle для русского и английского языка и добавляем их в artTitles
    artTitles = XMLElement("artTitles")
    create_xml_element(artTitles, "artTitle", {"lang": "RUS"}, metadata, 'titlerus')
    create_xml_element(artTitles, "artTitle", {"lang": "ENG"}, metadata, 'titleeng')
    article.add_child(artTitles)

    # Создаем элемент abstracts и добавляем его в article
    abstracts = XMLElement("abstracts")
    create_xml_element(abstracts, "abstract", {"lang": "RUS"}, metadata, 'annotationrus')
    create_xml_element(abstracts, "abstract", {"lang": "ENG"}, metadata, 'annotationeng')
    article.add_child(abstracts)

    text = XMLElement("text", attributes={"lang": "RUS"})
    text.text = metadata['article'][0]
    article.add_child(text)

    codes = XMLElement("codes")
    create_xml_element(codes, "udk", {}, metadata, 'udc')
    metadata['doi_text'] = [["10.31429/vestnik-" + VOLUME + "-" + ISSUE + "-" + first_page + "-" + last_page]]
    create_xml_element(codes, "doi", {}, metadata, 'doi_text')
    if 'EDN' in metadata and metadata['EDN']:
        create_xml_element(codes, "edn", {}, metadata, 'EDN')
    article.add_child(codes)

    keywords = XMLElement("keywords")
    kwdGroup_rus = XMLElement("kwdGroup", attributes={"lang": "RUS"})
    for kwd in metadata.get('keywordsrus', [[]])[0]:  # Используем метод get для безопасного получения значения
        keyword = XMLElement("keyword")
        keyword.text = kwd
        kwdGroup_rus.add_child(keyword)
    keywords.add_child(kwdGroup_rus)
    kwdGroup_eng = XMLElement("kwdGroup", attributes={"lang": "ENG"})
    for kwd in metadata.get('keywordseng', [[]])[0]:  # Используем метод get для безопасного получения значения
        keyword = XMLElement("keyword")
        keyword.text = kwd
        kwdGroup_eng.add_child(keyword)  # Исправлено здесь
    keywords.add_child(kwdGroup_eng)
    article.add_child(keywords)

    references = XMLElement("references")

    for ref in metadata.get('bibliography', []):  # Используем метод get для безопасного получения значения
        reference = XMLElement("reference")
        refInfo = XMLElement("refInfo", attributes={"lang": "ANY"})
        reftext = XMLElement("text")
        reftext.text = ref[1]
        refInfo.add_child(reftext)
        reference.add_child(refInfo)
        references.add_child(reference)

    article.add_child(references)

    if 'fundingrus' in metadata and metadata['fundingrus']:
        fundings = XMLElement("fundings")
        create_xml_element(fundings, "funding", {"lang": "RUS"}, metadata, 'fundingrus')
        create_xml_element(fundings, "funding", {"lang": "ENG"}, metadata, 'fundingeng')
        article.add_child(fundings)

    files = XMLElement("files")

    if 'OJS' in metadata and metadata['OJS']:
        filefullText = XMLElement("file", attributes={"lang": "RUS"})
        filefullText.set_attribute("desc", "fullText")
        filefullText.text = filename + ".pdf"
        files.add_child(filefullText)

        fileUrl = XMLElement("furl")
        fileUrl.set_attribute("desc", "description")
        fileUrl.text = "https://vestnik.kubsu.ru/article/view/" + metadata['OJS'][0][0]
        files.add_child(fileUrl)
    article.add_child(files)

    dates = XMLElement("dates")

    dateReceived = XMLElement("dateReceived")
    if metadata['date']:  # Проверяем, что список не пуст
        dateReceived.text = replace_date(metadata['date'][0][0])
    dates.add_child(dateReceived)
    dateAccepted = XMLElement("dateAccepted")
    if metadata['accepted']:  # Проверяем, что список не пуст
        dateAccepted.text = replace_date(metadata['accepted'][0][0])
    dates.add_child(dateAccepted)

    article.add_child(dates)

    print("Сохранено содержимое файла " + filename)
    return article

from datetime import datetime

def create_doi_xml(file_list, filename, metadatas):
    # Функция для разбора даты в формате ГГГГ-ММ-ДД
    def parse_date(date_string):
        day, month, year = date_string.split('-')
        return {'day': day, 'month': month, 'year': year}

    # Создаем корневой элемент
    root = XMLElement("doi_batch", attributes={"xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance", "xmlns": "http://www.crossref.org/schema/4.4.0", "version": "4.4.0", "xsi:schemaLocation": "http://www.crossref.org/schema/4.4.0 http://www.crossref.org/schemas/crossref4.4.0.xsd"})

    head = XMLElement("head")

    now = datetime.now()
    datetime_string = now.strftime("%Y%m%d%H%M%S")


    doi_batch_id = XMLElement("doi_batch_id", text="vestnik" + datetime_string)
    head.add_child(doi_batch_id)
    timestamp = XMLElement("timestamp", text=datetime_string)
    head.add_child(timestamp)

    depositor = XMLElement("depositor")
    depositor_name = XMLElement("depositor_name", text="ksut")
    depositor.add_child(depositor_name)
    email_address = XMLElement("email_address", text="mojar@kubsu.ru")
    depositor.add_child(email_address)
    head.add_child(depositor)
    registrant = XMLElement("registrant", text="Kuban State University")
    head.add_child(registrant)
    root.add_child(head)

    body = XMLElement("body")
    journal = XMLElement("journal")

    journal_metadata = XMLElement("journal_metadata")
    journal_title = XMLElement("full_title", text="Ecological Bulletin of Research Centers of the Black Sea Economic Cooperation")
    journal_metadata.add_child(journal_title)

    abbrev_title = XMLElement("abbrev_title", text="EBRC BSEC")
    journal_metadata.add_child(abbrev_title)

    issn = XMLElement("issn", attributes={"media_type": "print"}, text="1729-5459")
    journal_metadata.add_child(issn)

    doi_data = XMLElement("doi_data")
    doi = XMLElement("doi", text="10.31429/vestnik")
    doi_data.add_child(doi)
    resource = XMLElement("resource", text="https://vestnik.kubsu.ru")
    doi_data.add_child(resource)
    journal_metadata.add_child(doi_data)

    journal.add_child(journal_metadata)

    journal_issue = XMLElement("journal_issue")

    publication_date = XMLElement("publication_date", attributes={"media_type": "print"})
    month = XMLElement("month", text=parse_date(PRESSDATE)['month'])
    publication_date.add_child(month)
    day = XMLElement("day", text=parse_date(PRESSDATE)['day'])
    publication_date.add_child(day)
    year = XMLElement("year", text=parse_date(PRESSDATE)['year'])
    publication_date.add_child(year)
    journal_issue.add_child(publication_date)

    journal_volume = XMLElement("journal_volume")
    volume = XMLElement("volume", text=VOLUME)
    journal_volume.add_child(volume)
    journal_issue.add_child(journal_volume)

    issue = XMLElement("issue", text=ISSUE)
    journal_issue.add_child(issue)

    doi_data = XMLElement("doi_data")
    doi = XMLElement("doi", text="10.31429/vestnik-" + VOLUME + "-" + ISSUE)
    doi_data.add_child(doi)
    resource = XMLElement("resource", text="https://vestnik.kubsu.ru/issue/view/" + OJSISSUE)
    doi_data.add_child(resource)
    journal_issue.add_child(doi_data)
    journal.add_child(journal_issue)

    for file in file_list:
        journal.add_comment(file)
        metadata = metadatas[file]

        journal_article = XMLElement("journal_article", attributes={"publication_type": "full_text"})
        titles = XMLElement("titles")
        title = XMLElement("title", text=get_clean_latex(metadata['titleeng'][0][0]))
        titles.add_child(title)

        original_language_title = XMLElement("original_language_title", attributes={"language": "ru"}, text=get_clean_latex(metadata['titlerus'][0][0]))
        titles.add_child(original_language_title)

        journal_article.add_child(titles)

        contributors = XMLElement("contributors")
        for i, author in enumerate(metadata['authoreng_changed']):
            sequence = 'first' if i == 0 else 'additional'
            organization = XMLElement("organization", attributes={"sequence": sequence, "contributor_role": "author"},
                                      text=get_clean_latex(author[2]))
            contributors.add_child(organization)

            person_name = XMLElement("person_name", attributes={"sequence": sequence, "contributor_role": "author"})
            given_name = XMLElement("given_name", text=author[1])
            person_name.add_child(given_name)
            surname = XMLElement("surname", text=author[0])
            person_name.add_child(surname)
            contributors.add_child(person_name)
        journal_article.add_child(contributors)
        publication_date = XMLElement("publication_date", attributes={"media_type": "print"})
        month = XMLElement("month", text=parse_date(PRESSDATE)['month'])
        day = XMLElement("day", text=parse_date(PRESSDATE)['day'])
        year = XMLElement("year", text=parse_date(PRESSDATE)['year'])
        publication_date.add_child(month)
        publication_date.add_child(day)
        publication_date.add_child(year)
        journal_article.add_child(publication_date)

        first_page, last_page = get_page_numbers(file)
        if first_page and last_page:
            pages = XMLElement("pages")
            first_page = XMLElement("first_page", text=first_page)
            pages.add_child(first_page)
            last_page = XMLElement("last_page", text=last_page)
            pages.add_child(last_page)
            journal_article.add_child(pages)

        doi_data = XMLElement("doi_data")
        doi = XMLElement("doi", text="10.31429/vestnik-" + VOLUME + "-" + ISSUE + "-" + first_page.text + "-" + last_page.text)
        resource = XMLElement("resource", text="https://vestnik.kubsu.ru/article/view/" + metadata['OJS'][0][0])
        doi_data.add_child(doi)
        doi_data.add_child(resource)
        journal_article.add_child(doi_data)

        journal.add_child(journal_article)

    body.add_child(journal)
    root.add_child(body)

    # Создаем имя файла с суффиксом "_doi"
    doi_filename = "_vestnik_" + YEAR + "-" + ISSUE + "_doi.xml"

    # Записываем XML в файл
    with open(doi_filename, 'w') as outfile:
        outfile.write(root.to_xml())

PROGRAM_VERSION = "0.4.1"
def main():

    # Создаем парсер аргументов
    parser = argparse.ArgumentParser(prog='vestnik2xml', usage='%(prog)s [-v] [filename]',
                                     description='Converter for LaTeX/vestnik into elibrary.ru XML. Version ' + PROGRAM_VERSION)
    parser.add_argument('filename', help='LaTeX filename')
    parser.add_argument('-v', '--verbose', action='store_true', help='verbose output')
    args = parser.parse_args()

    print(f"vestnik2xml vesrsion {PROGRAM_VERSION}")

    # Проверяем, есть ли у файла расширение .tex
    filename = args.filename
    base_filename, extension = os.path.splitext(filename)
    if extension.lower() == '.tex':
        filename = base_filename  # Если есть, удаляем его

    # Проверяем, что файл существует
    tex_filename = filename + '.tex'
    if not os.path.isfile(tex_filename):
        print(f"Файл {tex_filename} не найден")
        return

    with open(tex_filename, 'r') as file:
        content = file.read()

    print("Анализируется содержимое файла " + filename + ".tex")

    print('----------')

    global YEAR, VOLUME, ISSUE, PRESSDATE, OJSISSUE
    YEAR = re.search(r'\\YEAR{(.*?)}', content).group(1)
    VOLUME = re.search(r'\\VOLUME{(.*?)}', content).group(1)
    ISSUE = re.search(r'\\ISSUE{(.*?)}', content).group(1)
    PRESSDATE = re.search(r'\\PRESSDATE{(.*?)}', content).group(1)
    OJSISSUE = re.search(r'\\OJSISSUE{(.*?)}', content).group(1)

    # Используем функцию parse_command для извлечения содержимого команды adda
    adda_contents = parse_command(content, 'adda')

    # Преобразуем список списков в простой список
    adda_contents = [item[0] for item in adda_contents]
    print("Обнаружены файлы для обработки: " + ', '.join(adda_contents))

    metadata = process_files(adda_contents)

    # Если указан параметр --verbose, выводим все метаданные
    if args.verbose:
        # Выводим результаты
        for article_filename in metadata:
            print(f"-----------\nФайл: {article_filename}")
            for key in metadata[article_filename]:
                print(f"Команда: {key}:")
                for item in metadata[article_filename][key]:
                    print(item)

    journal = merge_files(adda_contents, filename, metadata)

    new_filename = '_vestnik_' + YEAR + '-' + ISSUE + '.xml'
    with open(new_filename, 'w') as outfile:
        outfile.write("<?xml version='1.0' standalone='no' ?>\n")
        outfile.write(journal.to_xml())

    print('----------')
    print("Сохранен файл " + new_filename)

    # Загрузка xsd схемы
    xsd_file_name = r'journal.xsd'
    schema_root = etree.parse(xsd_file_name)
    schema = etree.XMLSchema(schema_root)

    # Загрузка xml
    xml_filename = new_filename
    xml = etree.parse(xml_filename)

    # Проверка
    if not schema.validate(xml):
        print(schema.error_log)
    else:
        print("Проверен файл "  + new_filename)

    # Создаем новый ZIP-архив
    with zipfile.ZipFile(new_filename.replace('.xml', '.zip'), 'w', compression=zipfile.ZIP_DEFLATED) as myzip:
        # Добавляем в архив XML-файл
        myzip.write(new_filename)

        # Добавляем в архив все PDF-файлы из списка adda_contents
        for file in adda_contents:
            pdf_filename = file + '.pdf'
            if os.path.isfile(pdf_filename):
                myzip.write(pdf_filename)
    print("Создан zip-архив " + new_filename)

    doi_filename = "_vestnik_" + YEAR + "-" + ISSUE + "_doi.xml"
    create_doi_xml(adda_contents, filename, metadata)
    print('----------')
    print("Сохранен файл " + doi_filename)

    # # Загрузка xsd схемы
    # xsd_file_name = r'crossref4.4.0.xsd'
    # try:
    #     schema_root = etree.parse(xsd_file_name)
    #     schema = etree.XMLSchema(schema_root)
    #     # parser = etree.XMLParser(schema=schema, no_network=False, ns_clean=True)
    # except KeyError as e:
    #     print(f"Произошла ошибка {e}")
    # except Exception as e:
    #     print(f"Произошла ошибка {e}")
    #
    # # Загрузка xml
    # xml_filename = filename + '_doi.xml'
    # try:
    #     xml = etree.parse(xml_filename)
    # except KeyError as e:
    #     print(f"Произошла ошибка {e}")
    # except Exception as e:
    #     print(f"Произошла ошибка {e}")
    #
    # # Проверка
    # if not schema.validate(xml):
    #     print(schema.error_log)
    # else:
    #     print("XML файл "  + filename + "_doi.xml" " успешно проверен по схеме", xsd_file_name)

if __name__ == "__main__":
    main()