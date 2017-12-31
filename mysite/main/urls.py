from django.conf.urls import url
from main import views

urlpatterns = [
    url(r'^$', views.IndexView.as_view(),name='index'),
    url(r'^log_reg_r$', views.Lr_rView.as_view(),name='lr_r'),
    url(r'^linear_r_p$', views.Linear_rView.as_view(),name='linear_r'),
    url(r'^midterm$', views.MidtermView.as_view(),name='midterm'),
    url(r'^about/$', views.AboutView.as_view(),name='about'),
    url(r'^nbeda$', views.NbEda.as_view(),name='nbeda'),
    url(r'^nbclt$', views.NbCltAndTtest.as_view(),name='nbclt'),

]
