#old
from django.shortcuts import render
from django.views.generic import TemplateView

# Create your views here.

class IndexView(TemplateView):
    template_name = 'index.html'

class Lr_rView(TemplateView):
    template_name = 'stats/logistic_regression/lr_r.html'

class NbViewTwo(TemplateView):
    template_name = 'stats/linear_regression/HW2_P.html'

class MidtermView(TemplateView):
    template_name = 'Blok 1/Multivariate Statistics/Midterm/mid-term.html'

class NbCltAndTtest(TemplateView):
    template_name = 'LearningR/clt_and_t-distribution.html'

class NbEda(TemplateView):
    template_name = 'LearningR/EDA.html'

class AboutView(TemplateView):
    template_name = 'about.html'
