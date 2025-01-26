from django import template
from ..models import LanguageNode

register = template.Library()

@register.simple_tag
def lang_disp(lang: LanguageNode) -> str:
    if lang.displayname:
        return lang.displayname
    else:
        return lang.name

# Use this if query used .values() (i.e., in list of entries)
@register.simple_tag
def lang_disp_vals(lang: dict) -> str:
    if lang['displayname']:
        return lang['displayname']
    else:
        return lang['name']