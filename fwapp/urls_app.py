from django.urls import path
from django.http import HttpResponsePermanentRedirect
from . import views

urlpatterns = [
    path('', views.home),
    path('languages', views.langs),
    path('languages/', lambda _: HttpResponsePermanentRedirect('/languages')),
    path('categories', views.cats),
    path('categories/', lambda _: HttpResponsePermanentRedirect('/categories')),
    path('random-term', views.random_term),
    path('random-term/', lambda _: HttpResponsePermanentRedirect('/random-term')),
    path('category/<slug:cat>', views.cat_detail),
    path('category/<slug:cat>/', lambda _, cat: HttpResponsePermanentRedirect(f'/category/{ cat }')),
    path('<slug:lang>', views.lang_detail),
    path('<slug:lang>/', lambda _, lang: HttpResponsePermanentRedirect(f'/{ lang }')),
    path('<slug:lang>/<slug:term>', views.term_detail),
    path('<slug:lang>/<slug:term>/', lambda _, lang, term: HttpResponsePermanentRedirect(f'/{ lang }/{ term }'))
]