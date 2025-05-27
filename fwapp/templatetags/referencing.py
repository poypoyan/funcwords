from django import template
import re

register = template.Library()

@register.simple_tag
def autolink(text: str) -> str:
    # this is limited because we only use this for references anyway
    punc = ['.', ',', ':', ';']
    find_http = r'(https://[^\s\)\]]+|http://[^\s\)\]]+)'
    save_idx = 0
    save_str = ''
    for i in re.finditer(find_http, text):
        last_char = i.group(0)[-1]
        if last_char in punc:
            removed_last_char = i.group(0)[:-1]
            save_str += f'{ text[save_idx: i.start()] }<a href="{ removed_last_char }">{ removed_last_char }</a>{ last_char }'
        else:
            save_str += f'{ text[save_idx: i.start()] }<a href="{ i.group(0) }">{ i.group(0) }</a>'
        save_idx = i.end()
    save_str += text[save_idx: len(text)]
    return save_str


@register.simple_tag
def citelink(text: str, ref_query) -> str:
    table = {}

    for i, j in enumerate(ref_query, start=1):
        table[f'[{ j['name'] }'] = f'[<a href="#ref-{ i }">{ i }</a>'

    if table == {}:
        return text

    ptrn = re.compile('|'.join(map(re.escape, table)))
    return ptrn.sub(lambda x: table[x.group(0)], text)