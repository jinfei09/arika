from django.http import HttpResponse
from django.template import Context, Template
from django.shortcuts import render_to_response

def index(request):
    return render_to_response("order_form.html", {})

def order(request):
    if 'q' in request.GET and request.GET['q']:
        return HttpResponse("You order is:[%r]" % request.GET['q'])
    else:
        return render_to_response('order_form.html', {'error': True})
