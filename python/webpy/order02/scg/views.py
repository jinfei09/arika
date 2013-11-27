import datetime
from django.shortcuts import render_to_response
'''
from scg.utils.auth import platform_login, platform_logout
from scg.forms import AuthenticationForm
from django.contrib.auth.forms import AuthenticationForm as AdminAuthenticationForm
from django.contrib.auth import login as platform_admin_login
from django.http import HttpResponse, HttpResponseRedirect
from django.core.urlresolvers import reverse
from django.views.decorators.csrf import  csrf_protect
from django.template import RequestContext
from scg.models import Account, Restaurant, Order, PayRecord
from scg.utils.decorators import login_required as scg_login_required
from django.contrib.auth.decorators import login_required as admin_login_required
'''
# Create your views here.
def login(request):
    return render_to_response("login.html")
'''
    if request.method == "POST":
        form = AuthenticationForm(data=request.POST)
        if form.is_valid():
            platform_login(request, form.get_user())

            if request.session.test_cookie_worked():
                request.session.delete_test_cookie()
            context = {
                'request':request,
            }
            redirect = request.GET.get('redirect', '/')
            return HttpResponseRedirect(redirect)
    else:
        form = AuthenticationForm(request)

    request.session.set_test_cookie()
    context = {
        'form': form,
    }
    context.update(extra_context or {})
    return render_to_response("login.html", context, context_instance=RequestContext(request)) 

'''
