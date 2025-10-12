# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.db.models import Q


class Reference(models.Model):
    name = models.CharField(max_length=50, unique=True, help_text='Codename for foreign key INSERT INTO.')
    info = models.TextField(db_default='', help_text='Kindly URI encode unsafe characters in URLs.')

    class Meta:
        db_table = 'reference'
    
    def __str__(self):
        return self.name


class LanguageNode(models.Model):
    # If node is dialect, please set a language as parent.
    # If node is language, please set a group as parent.
    name = models.CharField(max_length=50, unique=True, help_text='Make this unique. If this is a dialect, don\'t include the language name anymore.')
    nodetype = models.SmallIntegerField(help_text='0 = language, 1 = dialect, 2 = group.')
    parentnode = models.ForeignKey('self', models.DO_NOTHING, db_column='parentnode', blank=True, null=True)
    info = models.TextField(blank=True, db_default='')
    glottolog = models.CharField(max_length=50, blank=True, null=True)
    displayname = models.CharField(max_length=50)
    displaylinks = models.JSONField()
    refs = models.ManyToManyField(Reference, blank=True, help_text='In page, these are sorted by alphabetical order of Info field.<br/>')
    slug = models.SlugField()

    class Meta:
        db_table = 'language_node'
        constraints = [
            models.CheckConstraint(
                check=~(Q(nodetype=1) & Q(parentnode=None)),
                name='dialects should have parentnode'
            ),
        ]


class LanguageOtherName(models.Model):
    name = models.CharField(max_length=50)
    language = models.ForeignKey(LanguageNode, models.CASCADE, db_column='language')

    class Meta:
        db_table = 'language_othername'


class PropertyNode(models.Model):
    name = models.CharField(max_length=50)
    parentnode = models.ForeignKey('self', models.DO_NOTHING, db_column='parentnode', blank=True, null=True)
    info = models.TextField(blank=True, db_default='')
    displayname = models.CharField(max_length=100)
    displaylinks = models.JSONField()
    refs = models.ManyToManyField(Reference, blank=True, help_text='In page, these are sorted by alphabetical order of Info field.<br/>')
    slug = models.SlugField()

    class Meta:
        db_table = 'property_node'
        unique_together = (('name', 'parentnode'),)


class Term(models.Model):
    name = models.CharField(max_length=50, help_text='Please capitalize and you may add diacritics. This is the header in term page.')
    language = models.ForeignKey(LanguageNode, models.DO_NOTHING, db_column='language')
    info = models.TextField(blank=True, db_default='')
    linkname = models.CharField(max_length=50)
    refs = models.ManyToManyField(Reference, blank=True, help_text='In page, these are sorted by alphabetical order of Info field.<br/>')
    slug = models.SlugField()

    class Meta:
        db_table = 'term'


class TermProperty(models.Model):
    term = models.ForeignKey(Term, models.CASCADE, db_column='term')
    prop = models.ForeignKey(PropertyNode, models.CASCADE, db_column='prop')
    dispindex = models.IntegerField()

    class Meta:
        db_table = 'term_property'
        db_table_comment = "Associates a Property to a Term."
        unique_together = (('term', 'prop'),)
        verbose_name_plural = "Term properties"


class MainsContent(models.Model):
    # Must contain the following names:
    # * sitename - Website name. Used in title, metadata, and header of home page
    # * home - Content of home page
    # * langs - Content of languages page
    # * cats - Content of categories page
    # * fbconf - JSON config for funcbools

    name = models.CharField(max_length=50, unique=True)
    content = models.TextField(blank=True, db_default='')

    class Meta:
        db_table = 'mains_content'