#old
from django.shortcuts import render
from django.views.generic import TemplateView

# Create your views here.

class IndexView(TemplateView):
    template_name = 'index.html'

class Lr_rView(TemplateView):
    template_name = 'stats/logistic_regression/lr_r.html'

class Linear_rView(TemplateView):
    template_name = 'stats/linear_regression/linear_r.html'

class Xyplot_rView(TemplateView):
    template_name = 'stats/multilevel_regression/xyplot.html'

class AboutView(TemplateView):
    template_name = 'about.html'
