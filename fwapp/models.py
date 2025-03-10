# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models

# Columns starting with "Display" are denormalizations.

class LanguageNode(models.Model):
    # If node is dialect, please set a language as parent.
    # If node is language, please set a group as parent.
    name = models.CharField(db_column='Name', max_length=50, help_text='If this is a dialect, don\'t include the language name anymore.')
    nodetype = models.SmallIntegerField(db_column='NodeType', help_text='0 = language, 1 = dialect, 2 = group.<br/>For dialect, parent node <b>shouldn\'t be null!</b> Else, server error occurs.')
    parentnode = models.ForeignKey('self', models.DO_NOTHING, db_column='ParentNode', blank=True, null=True)
    info = models.TextField(db_column='Info', blank=True)
    displayname = models.CharField(db_column='DisplayName', max_length=50)
    displaylinks = models.JSONField(db_column='DisplayLinks')
    slug = models.SlugField(db_column='Slug')

    class Meta:
        db_table = 'Language_Node'


class PropertyNode(models.Model):
    name = models.CharField(db_column='Name', max_length=50)
    parentnode = models.ForeignKey('self', models.DO_NOTHING, db_column='ParentNode', blank=True, null=True)
    info = models.TextField(db_column='Info', blank=True)
    displayname = models.CharField(db_column='DisplayName', max_length=50)
    displaylinks = models.JSONField(db_column='DisplayLinks')
    slug = models.SlugField(db_column='Slug')

    class Meta:
        db_table = 'Property_Node'


class Term(models.Model):
    name = models.CharField(db_column='Name', max_length=50)
    language = models.ForeignKey(LanguageNode, models.DO_NOTHING, db_column='Language')
    info = models.TextField(db_column='Info', blank=True)
    slug = models.SlugField(db_column='Slug')

    class Meta:
        db_table = 'Term'


class TermProperty(models.Model):
    term = models.ForeignKey(Term, models.CASCADE, db_column='Term')
    prop = models.ForeignKey(PropertyNode, models.CASCADE, db_column='Prop')
    dispindex = models.IntegerField(db_column='DispIndex')

    class Meta:
        db_table = 'Term_Property'
        db_table_comment = "Associates a Property to a Term."
        unique_together = (('term', 'prop'),)
        verbose_name_plural = "Term properties"


class Reference(models.Model):
    name = models.CharField(db_column='Name', max_length=50)   # "codename" for foreign key INSERT INTO
    info = models.TextField(db_column='Info')

    class Meta:
        db_table = 'Reference'


class LanguageReference(models.Model):
    lang = models.ForeignKey(LanguageNode, models.CASCADE, db_column='Lang')
    ref = models.ForeignKey(Reference, models.CASCADE, db_column='Ref')
    dispindex = models.IntegerField(db_column='DispIndex')

    class Meta:
        db_table = 'Language_Reference'
        db_table_comment = "Associates a Reference to a Language."
        unique_together = (('lang', 'ref'),)


class PropertyReference(models.Model):
    prop = models.ForeignKey(PropertyNode, models.CASCADE, db_column='Prop')
    ref = models.ForeignKey(Reference, models.CASCADE, db_column='Ref')
    dispindex = models.IntegerField(db_column='DispIndex')

    class Meta:
        db_table = 'Property_Reference'
        db_table_comment = "Associates a Reference to a Property."
        unique_together = (('prop', 'ref'),)


class TermReference(models.Model):
    term = models.ForeignKey(Term, models.CASCADE, db_column='Term')
    ref = models.ForeignKey(Reference, models.CASCADE, db_column='Ref')
    dispindex = models.IntegerField(db_column='DispIndex')

    class Meta:
        db_table = 'Term_Reference'
        db_table_comment = "Associates a Reference to a Term."
        unique_together = (('term', 'ref'),)
