from django.urls import path
from . import views

urlpatterns = [
    path('', views.home),
    path('languages/', views.langs),
    path('categories/', views.cats),
    path('random-term/', views.random_term),
    path('category/<slug:cat>', views.cat_detail),
    path('<slug:lang>/', views.lang_detail),
    path('<slug:lang>/<slug:term>', views.term_detail)
]