from django.contrib import admin
from django.forms import ModelChoiceField
from django.utils.html import format_html
from django.db.models import Q
from .models import LanguageNode, LanguageOtherName, PropertyNode, Term, TermProperty, Reference, MainsContent
from .urls_app import URL_STR


class ForeignKeyDropDownDisp(ModelChoiceField):
    def label_from_instance(self, obj):
        return obj.displayname


class TermForeignKeyDropDownDisp(ModelChoiceField):
    def label_from_instance(self, obj):
        return f'{obj.linkname}, {obj.language.name}'


class LanguageStrictFilter(admin.SimpleListFilter):
    title = 'language'
    parameter_name = 'language__name'

    def lookups(self, request, model_admin):
        return [(c.name, c.name) for c in LanguageNode.objects.filter(Q(nodetype=0) | Q(nodetype=1))]

    def queryset(self, request, queryset):
        if self.value():
            return queryset.filter(language__name=self.value())
        else:
            return queryset


@admin.register(LanguageNode)
class LanguageNodeAdmin(admin.ModelAdmin):
    list_display = ('name', 'nodetype', 'parentnode__name')
    search_fields = ('name',)
    list_filter = ('nodetype',)
    readonly_fields = ('displayname', 'displaylinks', 'slug', 'actual_page')
    filter_horizontal = ('refs',)

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'parentnode':
            if 'object_id' in request.resolver_match.kwargs:
                return ForeignKeyDropDownDisp(queryset=LanguageNode.objects.exclude(id=request.resolver_match.kwargs['object_id']).order_by('name'))
            else:
                return ForeignKeyDropDownDisp(queryset=LanguageNode.objects.order_by('name'))
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        form.base_fields['parentnode'].required = False
        return form

    @admin.display(description='Actual Page')
    def actual_page(self, obj):
        if obj.id != None:
            return format_html('<a href="/{0}">/{0}</a>', obj.slug)
        else:
            return '-'


@admin.register(LanguageOtherName)
class LanguageOtherNameAdmin(admin.ModelAdmin):
    list_display = ('name', 'language__name')
    search_fields = ('name', 'language__name')

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'language':
            return ForeignKeyDropDownDisp(queryset=LanguageNode.objects.exclude(nodetype=2).order_by('name'))
        return super().formfield_for_foreignkey(db_field, request, **kwargs)


@admin.register(PropertyNode)
class PropertyNodeAdmin(admin.ModelAdmin):
    list_display = ('name', 'parentnode__name')
    search_fields = ('name',)
    readonly_fields = ('displayname', 'displaylinks', 'slug', 'actual_page')
    filter_horizontal = ('refs',)

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'parentnode':
            if 'object_id' in request.resolver_match.kwargs:
                return ForeignKeyDropDownDisp(queryset=PropertyNode.objects.exclude(id=request.resolver_match.kwargs['object_id']).order_by('name'))
            else:
                return ForeignKeyDropDownDisp(queryset=PropertyNode.objects.order_by('name'))
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        form.base_fields['parentnode'].required = False
        return form

    @admin.display(description='Actual Page')
    def actual_page(self, obj):
        if obj.id == None:
            return '-'
        else:
            return format_html('<a href="/{1}/{0}">/{1}/{0}</a>', obj.slug, URL_STR['cat'])


@admin.register(Term)
class TermAdmin(admin.ModelAdmin):
    list_display = ('linkname', 'language__name')
    search_fields = ('linkname',)
    list_filter = (LanguageStrictFilter,)
    readonly_fields = ('linkname', 'slug', 'actual_page')
    filter_horizontal = ('refs',)

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'language':
            return ForeignKeyDropDownDisp(queryset=LanguageNode.objects.exclude(nodetype=2).order_by('name'))
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    @admin.display(description='Actual Page')
    def actual_page(self, obj):
        if obj.id == None:
            return '-'
        else:
            return format_html('<a href="/{0}/{1}">/{0}/{1}</a>', obj.language.slug, obj.slug)


@admin.register(TermProperty)
class TermPropertyAdmin(admin.ModelAdmin):
    list_display = ('term_lang', 'prop__displayname', 'dispindex')
    search_fields = ('term__linkname', 'term__language__name', 'prop__displayname')

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'term':
            return TermForeignKeyDropDownDisp(queryset=Term.objects.all().order_by('name'))
        if db_field.name == 'prop':
            return ForeignKeyDropDownDisp(queryset=PropertyNode.objects.all().order_by('name'))
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    @admin.display()
    def term_lang(self, obj):
        return f'{obj.term.linkname}, {obj.term.language.name}'


@admin.register(Reference)
class ReferenceAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)


@admin.register(MainsContent)
class MainsContent(admin.ModelAdmin):
    list_display = ('name',)
    readonly_fields = ('actual_page',)

    @admin.display(description='Actual Page')
    def actual_page(self, obj):
        if obj.name == 'home':
            return format_html('<a href="/">/</a>')
        elif obj.name in ['langs', 'cats']:
            return format_html('<a href="/{0}">/{0}</a>', URL_STR[obj.name])
        else:
            return '-'