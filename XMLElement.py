import html

class XMLElement:
    def __init__(self, tag, attributes=None, children=None, lang=None, text=None):
        self.tag = tag
        self.attributes = attributes if attributes else {}
        if lang is not None:
            self.attributes['lang'] = lang
        self.children = children if children else []
        self.text = text
        self.parent = None
        self.indent_level = 0

    def add_prolog(self, prolog):
        self.prolog = prolog

    def add_comment(self, comment, indent_level=0):
        indent = '  ' * indent_level
        self.children.append(f"{indent}<!-- {comment} -->")

    def add_child(self, child):
        child.parent = self
        child.indent_level = self.indent_level + 1  # Увеличиваем уровень отступа
        self.children.append(child)

    def set_attribute(self, key, value):
        self.attributes[key] = value

    def _serialize_attributes(self):
        return ' '.join(f'{k}="{html.escape(str(v))}"' for k, v in self.attributes.items())

    def _serialize_children(self, indent_level=0):
        serialized_children = []
        for child in self.children:
            if isinstance(child, (XMLElement, RawHTML)):
                serialized_children.append(child.to_xml(indent_level + 1))
            else:  # Assume child is a string
                indent = '  ' * (indent_level + 1)
                serialized_children.append(indent + html.escape(child))
        return '\n'.join(serialized_children)

    def to_xml(self, indent_level=0):
        indent = '  ' * indent_level
        attributes = self._serialize_attributes()
        children = self._serialize_children(indent_level + 1)

        if attributes:
            start_tag = f'<{self.tag} {attributes}>'
        else:
            start_tag = f'<{self.tag}>'
        end_tag = f'</{self.tag}>'

        # В месте вызова add_comment передаем indent_level
        self.add_comment(self.tag, indent_level)

        if self.parent is None:  # Если это корневой элемент
            if hasattr(self, 'prolog'):  # Если пролог был добавлен
                return self.prolog + '\n' + self._serialize_xml(indent, start_tag, children, end_tag)
            elif hasattr(self, 'root'):  # Если пролог был добавлен
                return ''
            else:
                return self._serialize_xml(indent, start_tag, children, end_tag)
        elif self.text or children.strip():  # Если есть текстовое содержимое или дети
            return self._serialize_xml(indent, start_tag, children, end_tag)
        else:  # Если нет текстового содержимого и детей
            return ''

    def _serialize_xml(self, indent, start_tag, children, end_tag):
        if self.text:  # Если есть текстовое содержимое, добавляем его внутрь тега
            return f'{indent}{start_tag}{self.text}{end_tag}'
        elif not children.strip():  # Если детей нет, используем однострочный тег
            return f'{indent}{start_tag}{end_tag}'
        elif len(self.children) == 1 and isinstance(self.children[0], str):  # Если один ребенок и это строка
            # Добавляем текст без переносов строк и без дополнительных отступов
            return f'{indent}{start_tag}{children.strip()}{end_tag}'
        else:  # В остальных случаях форматируем с переносами строк и отступами
            return f'{indent}{start_tag}\n{children}\n{indent}{end_tag}'

    def _serialize_children(self, indent_level=0):
        serialized_children = []
        for child in self.children:
            if isinstance(child, (XMLElement, RawHTML)):
                serialized_children.append(child.to_xml(indent_level + 1))
            else:  # Assume child is a string
                serialized_children.append(child.strip())  # Удаление лишних пробелов
        return '\n'.join(serialized_children)

class RawHTML:
    def __init__(self, html_content):
        self.html_content = html_content

    def to_xml(self, indent_level=0):
        return self.html_content
