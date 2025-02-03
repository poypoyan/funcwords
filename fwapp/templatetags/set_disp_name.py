from django import template
from ..models import LanguageNode

register = template.Library()

@register.simple_tag
def lang_disp(displayname: str, name: str) -> str:
    return displayname if displayname else name