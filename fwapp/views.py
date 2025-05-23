from django.shortcuts import render, redirect
from django.core.paginator import Paginator
from django.db.models import Q
from django.http import Http404
from urllib.parse import urlencode
from . import models
from .forms import SearchForm
import random


_PAGE_ENTRIES = 30


def error_404(request, exception):
    return render(request, 'error_404.html')


def error_500(request):
    return render(request, 'error_500.html')


def home(request):
    return render(request, 'home.html')


def langs(request):
    langs_query = models.LanguageNode.objects.values('displayname', 'slug').filter(Q(nodetype=0) | Q(nodetype=1)).order_by('displayname')
    langs_ct = langs_query.count()

    paginator = Paginator(langs_query, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'langs.html', { 'langs': page_obj, 'langs_ct': langs_ct, 'per_page': _PAGE_ENTRIES })


def lang_detail(request, lang):
    try:
        lang_query = models.LanguageNode.objects.get(slug=lang)
    except models.LanguageNode.DoesNotExist:
        raise Http404

    lang_children_query = models.LanguageNode.objects.values('name', 'slug').filter(parentnode=lang_query.id).order_by('name')
    langs_ct = lang_children_query.count()
    terms_query = models.Term.objects.values('name', 'slug').filter(language=lang_query.id).order_by('name')
    terms_ct = terms_query.count()
    refs_query = models.Reference.objects.values('info').filter(languagereference__lang=lang_query.id).order_by('languagereference__dispindex')

    paginator = Paginator(terms_query, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'lang_detail.html', { 'lang': lang_query, 'lang_children': lang_children_query, 'langs_ct': langs_ct, 'terms': page_obj, 'terms_ct': terms_ct, 'refs': refs_query, 'per_page': _PAGE_ENTRIES })


def term_detail(request, lang, term):
    try:
        lang_query = models.LanguageNode.objects.values('id', 'nodetype', 'displayname', 'slug').get(slug=lang)
        term_query = models.Term.objects.get(slug=term, language=lang_query['id'])
    except (models.LanguageNode.DoesNotExist, models.Term.DoesNotExist):
        raise Http404

    props_query = models.PropertyNode.objects.values('name', 'displaylinks', 'slug').filter(termproperty__term=term_query.id).order_by('termproperty__dispindex')
    refs_query = models.Reference.objects.values('info').filter(termreference__term=term_query.id).order_by('termreference__dispindex')
    return render(request, 'term_detail.html', { 'lang': lang_query, 'term': term_query, 'props': props_query, 'refs': refs_query })


def cats(request):
    cats_query = models.PropertyNode.objects.values('displayname', 'slug').order_by('displayname')
    cats_ct = cats_query.count()

    paginator = Paginator(cats_query, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'cats.html', { 'cats': page_obj, 'cats_ct': cats_ct, 'per_page': _PAGE_ENTRIES })


def cat_detail(request, cat):
    try:
        cat_query = models.PropertyNode.objects.get(slug=cat)
    except models.PropertyNode.DoesNotExist:
        raise Http404

    cat_children_query = models.PropertyNode.objects.values('name', 'slug').filter(parentnode=cat_query.id).order_by('name')
    cats_ct = cat_children_query.count()
    terms_query = models.Term.objects.values('name', 'slug', 'language__displayname', 'language__slug').filter(termproperty__prop=cat_query.id).order_by('name')
    terms_ct = terms_query.count()
    refs_query = models.Reference.objects.values('info').filter(propertyreference__prop=cat_query.id).order_by('propertyreference__dispindex')

    paginator = Paginator(terms_query, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'cat_detail.html', { 'cat': cat_query, 'cat_children': cat_children_query, 'cats_ct': cats_ct, 'terms': page_obj, 'terms_ct': terms_ct, 'refs': refs_query , 'per_page': _PAGE_ENTRIES})


def random_term(_):
    terms_all = models.Term.objects.values_list('id', flat=True)
    if not terms_all:
        return redirect('/languages')
    rnd_id = random.choice(terms_all)
    term_query = models.Term.objects.values('slug', 'language').get(id=rnd_id)
    lang_query = models.LanguageNode.objects.values('slug').get(id=term_query['language'])
    return redirect(f'/{ lang_query["slug"] }/{ term_query["slug"] }')


def search(request):
    if len(request.GET) == 0:
        return render(request, 'search.html', { 'form': SearchForm(), 'type_select': None, 'results': None })

    form = SearchForm(request.GET)
    if not form.is_valid():
        return redirect('/search')   # remove GET parameters in current url

    # basic search (not full text)
    searched = form.cleaned_data['q']
    if form.cleaned_data['t'] == 'term':
        results = models.Term.objects.values('name', 'slug', 'language__displayname', 'language__slug').filter(Q(name__unaccent__trigram_similar=searched) | Q(name__unaccent__icontains=searched)).order_by('name')
    elif form.cleaned_data['t'] == 'language':
        results = models.LanguageNode.objects.values('displayname', 'slug').filter(Q(displayname__unaccent__trigram_similar=searched) | Q(displayname__unaccent__icontains=searched)).order_by('displayname')
    elif form.cleaned_data['t'] == 'category':
        results = models.PropertyNode.objects.values('displayname', 'slug').filter(Q(displayname__unaccent__trigram_similar=searched) | Q(displayname__unaccent__icontains=searched)).order_by('displayname')

    results_ct = results.count()

    paginator = Paginator(results, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'search.html', { 'form': form, 'type_select': form.cleaned_data['t'], 'results': page_obj, 'results_ct': results_ct, 'bef_get_params': urlencode(form.cleaned_data) + '&', 'per_page': _PAGE_ENTRIES })