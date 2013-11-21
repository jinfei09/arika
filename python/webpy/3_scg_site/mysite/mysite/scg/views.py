from django.http import HttpResponse
from django.template import Context, Template
from django.shortcuts import render_to_response

def index(req):
#    return HttpResponse("index.html", {})
    return render_to_response("index.html", {})
