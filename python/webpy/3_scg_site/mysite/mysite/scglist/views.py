from django.shortcuts import render_to_response

def index(req):
    order_list = ['a', 'b', 'c']
    order_dict = {'name': "chenf", 'age':23}
    return render_to_response("scg_list.html", {"order_list":order_list, "order_dict":order_dict})
