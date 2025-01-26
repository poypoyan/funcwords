from django.shortcuts import render, redirect
from django.db.models import Q
from . import models
import random

# Create your views here.

def error_404(request, exception):
    return render(request, 'error_404.html')

def error_500(request):
    return render(request, 'error_500.html')

def home(request):
    return render(request, 'home.html')

def langs(request):
    langs_query = models.LanguageNode.objects.values('name', 'displayname', 'slug').filter(Q(nodetype=0) | Q(nodetype=1))
    return render(request, 'langs.html', { 'langs': langs_query })

def lang_detail(request, lang):
    lang_query = models.LanguageNode.objects.get(slug=lang)
    lang_children_query = models.LanguageNode.objects.values('name', 'displayname', 'slug').filter(parentnode=lang_query.id)
    terms_query = models.Term.objects.values('name', 'slug').filter(language=lang_query.id)
    refs_query = models.Reference.objects.order_by('languagereference__dispindex').values('info').filter(languagereference__lang=lang_query.id)
    return render(request, 'lang_detail.html', { 'lang': lang_query, 'lang_children': lang_children_query, 'terms': terms_query, 'refs': refs_query })

def term_detail(request, lang, term):
    lang_query = models.LanguageNode.objects.values('id', 'name', 'nodetype', 'displayname', 'slug').get(slug=lang)
    term_query = models.Term.objects.get(slug=term, language=lang_query['id'])
    props_query = models.PropertyNode.objects.order_by('termproperty__dispindex').values('name', 'displaylinks', 'slug').filter(termproperty__term=term_query.id)
    refs_query = models.Reference.objects.order_by('termreference__dispindex').values('info').filter(termreference__term=term_query.id)
    return render(request, 'term_detail.html', { 'lang': lang_query, 'term': term_query, 'props': props_query, 'refs': refs_query })

def cats(request):
    cats_query = models.PropertyNode.objects.values('name', 'displayname', 'slug')
    return render(request, 'cats.html', { 'cats': cats_query })

def cat_detail(request, cat):
    cat_query = models.PropertyNode.objects.get(slug=cat)
    refs_query = models.Reference.objects.order_by('propertyreference__dispindex').values('info').filter(propertyreference__prop=cat_query.id)
    return render(request, 'cat_detail.html', { 'cat': cat_query, 'refs': refs_query })

def random_term(request):
    terms_all = models.Term.objects.values_list('id', flat=True)
    rnd_id = random.choice(terms_all)
    term_query = models.Term.objects.values('slug', 'language').get(id=rnd_id)
    lang_query = models.LanguageNode.objects.values('slug').get(id=term_query['language'])
    return redirect('/' + lang_query['slug'] + '/' + term_query['slug'])