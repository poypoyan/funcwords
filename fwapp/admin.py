from django.contrib import admin
from django.forms import ModelChoiceField
from .models import LanguageNode, PropertyNode, Term, TermProperty, Reference, LanguageReference, PropertyReference, TermReference

class ForeignKeyDropDownDisp(ModelChoiceField):
    def label_from_instance(self, obj):
        return obj.name

class TermForeignKeyDropDownDisp(ModelChoiceField):
    def label_from_instance(self, obj):
        return f'{obj.name}, {obj.language.name}'

# Register your models here.
@admin.register(LanguageNode)
class LanguageNodeAdmin(admin.ModelAdmin):
    list_display = ('name', 'nodetype', 'parentnode__name')
    search_fields = ('name',)
    list_filter = ('nodetype', 'parentnode__name')
    exclude = ('displayname', 'displaylinks', 'slug')

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'parentnode':
            if 'object_id' in request.resolver_match.kwargs:
                return ForeignKeyDropDownDisp(queryset=LanguageNode.objects.exclude(id=request.resolver_match.kwargs['object_id']))
            else:
                return ForeignKeyDropDownDisp(queryset=LanguageNode.objects)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        form.base_fields['parentnode'].required = False
        return form

@admin.register(PropertyNode)
class PropertyNodeAdmin(admin.ModelAdmin):
    list_display = ('name', 'parentnode__name')
    search_fields = ('name',)
    list_filter = ('name', 'parentnode__name')
    exclude = ('displayname', 'displaylinks', 'slug')

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'parentnode':
            if 'object_id' in request.resolver_match.kwargs:
                return ForeignKeyDropDownDisp(queryset=PropertyNode.objects.exclude(id=request.resolver_match.kwargs['object_id']))
            else:
                return ForeignKeyDropDownDisp(queryset=PropertyNode.objects)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        form.base_fields['parentnode'].required = False
        return form

@admin.register(Term)
class TermAdmin(admin.ModelAdmin):
    list_display = ('name', 'language__name')
    search_fields = ('name',)
    list_filter = ('name', 'language__name')
    exclude = ('slug',)

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'language':
            return ForeignKeyDropDownDisp(queryset=LanguageNode.objects.exclude(nodetype=2))
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

@admin.register(TermProperty)
class TermPropertyAdmin(admin.ModelAdmin):
    list_display = ('term_lang', 'prop__name', 'dispindex')
    list_filter = ('term__name', 'prop__name')

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'term':
            return TermForeignKeyDropDownDisp(queryset=Term.objects.all())
        if db_field.name == 'prop':
            return ForeignKeyDropDownDisp(queryset=PropertyNode.objects.all())
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    @admin.display()
    def term_lang(self, obj):
        return f'{obj.term.name}, {obj.term.language.name}'

@admin.register(Reference)
class ReferenceAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)

@admin.register(LanguageReference)
class LanguageReferenceAdmin(admin.ModelAdmin):
    list_display = ('lang__name', 'ref__name', 'dispindex')
    list_filter = ('lang__name', 'ref__name')

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'lang':
            return ForeignKeyDropDownDisp(queryset=LanguageNode.objects.all())
        if db_field.name == 'ref':
            return ForeignKeyDropDownDisp(queryset=Reference.objects.all())
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

@admin.register(PropertyReference)
class PropertyReferenceAdmin(admin.ModelAdmin):
    list_display = ('prop__name', 'ref__name', 'dispindex')
    list_filter = ('prop__name', 'ref__name')

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'prop':
            return ForeignKeyDropDownDisp(queryset=PropertyNode.objects.all())
        if db_field.name == 'ref':
            return ForeignKeyDropDownDisp(queryset=Reference.objects.all())
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

@admin.register(TermReference)
class TermReferenceAdmin(admin.ModelAdmin):
    list_display = ('term_lang', 'ref__name', 'dispindex')
    list_filter = ('term__name', 'ref__name')

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'term':
            return ForeignKeyDropDownDisp(queryset=Term.objects.all())
        if db_field.name == 'ref':
            return ForeignKeyDropDownDisp(queryset=Reference.objects.all())
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    @admin.display()
    def term_lang(self, obj):
        return f'{obj.term.name}, {obj.term.language.name}'