from django.shortcuts import render, redirect
from django.core.paginator import Paginator
from django.contrib.postgres.search import TrigramSimilarity
from django.db.models import Q
from django.db.models.functions import Greatest
from django.http import Http404
from urllib.parse import urlencode
from . import models
from .forms import SearchForm
from .funcbool import conf as funcbool_conf
from .funcbool.main import bool_proc
import random


_PAGE_ENTRIES = 30


def error_404(request, exception):
    return render(request, 'error_404.html',
        {
            'is_nofollow': True,
            'title': 'Error 404'
        },
    status=404)


def error_500(request):
    return render(request, 'error_500.html',
        {
            'is_nofollow': True,
            'title': 'Error 500'
        },
    status=500)


def home(request):
    try:
        content = models.MainsContent.objects.get(name='home').content
    except models.MainsContent.DoesNotExist:
        content = ''

    return render(request, 'home.html',
        {
            'content': content,
            'description': 'Start here to explore function words in various Philippine languages.'
        }
    )


def langs(request):
    langs_query = models.LanguageNode.objects.values('displayname', 'slug').filter(Q(nodetype=0) | Q(nodetype=1)).order_by('displayname')
    langs_ct = langs_query.count()

    try:
        content = models.MainsContent.objects.get(name='langs').content
    except models.MainsContent.DoesNotExist:
        content = ''

    paginator = Paginator(langs_query, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'langs.html',
        {
            'content': content,
            'langs': page_obj,
            'langs_ct': langs_ct,
            'per_page': _PAGE_ENTRIES,
            'title': 'Languages',
            'description': 'Current list of languages.'
        }
    )


def lang_detail(request, lang):
    try:
        lang_query = models.LanguageNode.objects.get(slug=lang)
    except models.LanguageNode.DoesNotExist:
        raise Http404

    lang_children_query = models.LanguageNode.objects.values('name', 'slug').filter(parentnode=lang_query.id).order_by('name')
    lang_othernames_query = models.LanguageOtherName.objects.values('name').filter(language=lang_query.id).order_by('name')
    langs_ct = lang_children_query.count()
    terms_query = models.Term.objects.values('linkname', 'slug').filter(language=lang_query.id).order_by('linkname')
    terms_ct = terms_query.count()
    refs_query = models.Reference.objects.values().filter(languagenode=lang_query.id).order_by('info')

    paginator = Paginator(terms_query, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'lang_detail.html',
        {
            'lang': lang_query,
            'lang_children': lang_children_query,
            'langs_ct': langs_ct,
            'lang_on': lang_othernames_query,
            'terms': page_obj,
            'terms_ct': terms_ct,
            'refs': refs_query,
            'per_page': _PAGE_ENTRIES,
            'title': f'{ lang_query.displayname }',
            'description': f'Some information about { lang_query.displayname } language/dialect/language group.'
        }
    )


def term_detail(request, lang, term):
    try:
        lang_query = models.LanguageNode.objects.values('id', 'nodetype', 'displayname', 'slug').get(slug=lang)
        term_query = models.Term.objects.get(slug=term, language=lang_query['id'])
    except (models.LanguageNode.DoesNotExist, models.Term.DoesNotExist):
        raise Http404

    props_query = models.PropertyNode.objects.values('name', 'displaylinks', 'slug').filter(termproperty__term=term_query.id).order_by('termproperty__dispindex')
    refs_query = models.Reference.objects.values().filter(term=term_query.id).order_by('info')
    return render(request, 'term_detail.html',
        {
            'lang': lang_query,
            'term': term_query,
            'props': props_query,
            'refs': refs_query,
            'title': f'{ term_query.linkname } ({ lang_query['displayname'] })',
            'description': f'Some information about the word { term_query.linkname } from the { lang_query['displayname'] } language/dialect.'
        }
    )


def term_other(request, lang, term):
    try:
        lang_query = models.LanguageNode.objects.values('id', 'displayname', 'slug').get(slug=lang)
        term_query = models.Term.objects.values('id', 'name', 'linkname', 'slug').get(slug=term, language=lang_query['id'])
    except (models.LanguageNode.DoesNotExist, models.Term.DoesNotExist):
        raise Http404

    props_query = models.PropertyNode.objects.values('id', 'displayname', 'slug').filter(termproperty__term=term_query['id']).order_by('termproperty__dispindex')
    idx_bool = bool_proc(props_query, funcbool_conf.config, funcbool_conf.filt)

    # process funcbool output
    if len(idx_bool) == 0:
        terms_query = models.Term.objects.none()
    else:
        terms_query = models.Term.objects.values('linkname', 'slug', 'language__displayname', 'language__slug').filter(~Q(id=term_query['id']))

    conds_disp = ''
    conds_first = True
    for i in idx_bool:
        if conds_first:
            conds_first = False
        else:
            conds_disp += ' AND '
        
        if len(i) == 1:
            terms_query = terms_query.filter(termproperty__prop=props_query[i[0]]['id'])
            conds_disp += f'<a href="/category/{ props_query[i[0]]['slug'] }">{ props_query[i[0]]['displayname'] }</a>'
        else:
            or_clause = Q()
            or_disp = ''
            or_first = True
            for j in i:
                if or_first:
                    or_first = False
                    or_disp += '('
                else:
                    or_disp += ' OR '

                or_clause |= Q(termproperty__prop=props_query[j]['id'])
                or_disp += f'<a href="/category/{ props_query[j]['slug'] }">{ props_query[j]['displayname'] }</a>'

            terms_query = terms_query.filter(or_clause)
            conds_disp += or_disp + ')'

    terms_query = terms_query.order_by('linkname')
    terms_ct = terms_query.count()

    paginator = Paginator(terms_query, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'term_other.html',
        {
            'lang': lang_query,
            'term': term_query,
            'conds_disp': conds_disp,
            'terms_new': page_obj,
            'terms_new_ct': terms_ct,
            'title': f'Other terms like { term_query['linkname'] } ({ lang_query['displayname'] })',
            'description': f'Current list of terms similar to the word { term_query['linkname'] } from the { lang_query['displayname'] } language/dialect.'
        }
    )


def cats(request):
    cats_query = models.PropertyNode.objects.values('displayname', 'slug').order_by('displayname')
    cats_ct = cats_query.count()

    try:
        content = models.MainsContent.objects.get(name='cats').content
    except models.MainsContent.DoesNotExist:
        content = ''

    paginator = Paginator(cats_query, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'cats.html',
        {
            'content': content,
            'cats': page_obj,
            'cats_ct': cats_ct,
            'per_page': _PAGE_ENTRIES,
            'title': 'Categories',
            'description': 'Current list of categories for function words.'
        }
    )


def cat_detail(request, cat):
    try:
        cat_query = models.PropertyNode.objects.get(slug=cat)
    except models.PropertyNode.DoesNotExist:
        raise Http404

    cat_children_query = models.PropertyNode.objects.values('name', 'slug').filter(parentnode=cat_query.id).order_by('name')
    cats_ct = cat_children_query.count()
    terms_query = models.Term.objects.values('linkname', 'slug', 'language__displayname', 'language__slug').filter(termproperty__prop=cat_query.id).order_by('linkname')
    terms_ct = terms_query.count()
    refs_query = models.Reference.objects.values().filter(propertynode=cat_query.id).order_by('info')

    paginator = Paginator(terms_query, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'cat_detail.html',
        {
            'cat': cat_query,
            'cat_children': cat_children_query,
            'cats_ct': cats_ct,
            'terms': page_obj,
            'terms_ct': terms_ct,
            'refs': refs_query ,
            'per_page': _PAGE_ENTRIES,
            'title': f'{ cat_query.displayname }',
            'description': f'Some information about { cat_query.displayname }.'
        }
    )


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
        return render(request, 'search.html',
            {
                'form': SearchForm(),
                'type_select': None,
                'results': None,
                'is_search': True,
                'title': 'Search',
                'description': 'Search for a term, language, or category.'
            }
        )

    form = SearchForm(request.GET)
    if not form.is_valid():
        return redirect('/search')   # remove GET parameters in current url

    # basic search (not full text)
    searched = form.cleaned_data['q']
    if form.cleaned_data['t'] == 'term':
        # linkname is already unaccented
        results = models.Term.objects.values('linkname', 'slug', 'language__displayname', 'language__slug').filter(
                Q(linkname__trigram_similar=searched) | Q(linkname__icontains=searched)
            ).annotate(similarity=TrigramSimilarity('linkname', searched)
            ).order_by('-similarity', 'linkname')
    elif form.cleaned_data['t'] == 'language':
        results = models.LanguageNode.objects.values('displayname', 'slug').filter(
                Q(displayname__unaccent__trigram_similar=searched) | Q(displayname__unaccent__icontains=searched) |
                Q(languageothername__name__unaccent__trigram_similar=searched) | Q(languageothername__name__unaccent__icontains=searched)
            ).annotate(similarity=Greatest(TrigramSimilarity('displayname__unaccent', searched), TrigramSimilarity('languageothername__name__unaccent', searched))
            ).order_by('-similarity', 'displayname')
    elif form.cleaned_data['t'] == 'category':
        results = models.PropertyNode.objects.values('displayname', 'slug').filter(
                Q(displayname__unaccent__trigram_similar=searched) | Q(displayname__unaccent__icontains=searched)
            ).annotate(similarity=TrigramSimilarity('displayname__unaccent', searched)
            ).order_by('-similarity', 'displayname')

    results_ct = results.count()

    paginator = Paginator(results, _PAGE_ENTRIES)
    page_obj = paginator.get_page(request.GET.get("page"))
    return render(request, 'search.html',
        {
            'form': form,
            'type_select': form.cleaned_data['t'],
            'results': page_obj,
            'results_ct': results_ct,
            'bef_get_params': urlencode(form.cleaned_data) + '&',
            'per_page': _PAGE_ENTRIES,
            'is_search': True,
            'is_nofollow': True,
            'title': f'Search results for \'{ searched }\'',
        }
    )