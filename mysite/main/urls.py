from django.conf.urls import url
from main import views

urlpatterns = [
    url(r'^$', views.IndexView.as_view(),name='index'),
    url(r'^log_reg_r$', views.Lr_rView.as_view(),name='lr_r'),
    url(r'^linear_r_p$', views.Linear_rView.as_view(),name='linear_r'),
    url(r'^xyplot$', views.XyplotView.as_view(),name='xyplot_r'),
    url(r'^about/$', views.AboutView.as_view(),name='about'),
]
