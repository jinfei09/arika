from django.http import Http404,HttpResponse

def hello(request):
    return HttpResponse("Hello world, Welcome to page at %s" % request.path)

