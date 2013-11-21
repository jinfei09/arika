from django.shortcuts import render
from django.shortcuts import render_to_response
from blog.models import Employee

def index(req):
    emps = Employee.objects.all()
    return render_to_response('index.html', {'emps':emps})
