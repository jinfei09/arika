from django.shortcuts import render_to_response
class Person(object):
    def __init__(self, name, age, sex):
        self.name = name
        self.age = age
        self.sex = sex
    def say(self):
        return "I'm  " + self.name

def index(req):
    #user = {'name':'arika', 'age':23, 'sex':'male'}
    user = Person('arika', 23, 'male')
    book_list = ['python', 'java', 'php', 'web']
    return render_to_response('index.html', {'title': 'SCG', 'book_list':book_list, 'user':user})


'''
from django.http import HttpResponse
from django.template import loader, Context

def index(req):
    t = loader.get_template('index.html')
    c = Context({})

#    return HttpResponse('<h1>Hello Django</h1>')
    return HttpResponse(t.render(c))
'''
