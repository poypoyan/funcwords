from django.urls import path
from django.http import HttpResponsePermanentRedirect
from . import views


URL_STR = {
    'langs': 'languages',
    'cats': 'categories',
    'cat': 'category',
    'rnd': 'random-term',
    'search': 'search',
    'other': 'other'
}


urlpatterns = [
    path('', views.home),
    path(f'{ URL_STR['langs'] }/', views.langs),
    path(f'{ URL_STR['cats'] }/', views.cats),
    path(f'{ URL_STR['rnd'] }/', views.random_term),
    path(f'{ URL_STR['search'] }/', views.search),
    path(f'{ URL_STR['cat'] }/<slug:cat>', views.cat_detail),
    path('<slug:lang>/', views.lang_detail),
    path('<slug:lang>/<slug:term>', views.term_detail),
    path(f'<slug:lang>/<slug:term>/{ URL_STR['other'] }', views.term_other)
]