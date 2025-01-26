from django.contrib import admin
from .models import LanguageNode, PropertyNode, Term, TermProperty, Reference, LanguageReference, PropertyReference, TermReference

# Register your models here.
admin.site.register(LanguageNode)
admin.site.register(PropertyNode)
admin.site.register(Term)
admin.site.register(TermProperty)
admin.site.register(Reference)
admin.site.register(LanguageReference)
admin.site.register(PropertyReference)
admin.site.register(TermReference)