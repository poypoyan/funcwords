from django.urls import path
from django.http import HttpResponsePermanentRedirect
from . import views


urlpatterns = [
    path('', views.home),
    path('languages/', views.langs),
    path('categories/', views.cats),
    path('random-term', views.random_term),
    path('search', views.search),
    path('category/<slug:cat>', views.cat_detail),
    path('<slug:lang>/', views.lang_detail),
    path('<slug:lang>/<slug:term>', views.term_detail),
]