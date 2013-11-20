from django.conf.urls import patterns, include, url
from django.conf.urls.defaults import *
from django.contrib import admin
from django.conf import settings
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'mysite.views.home', name='home'),
    # url(r'^mysite/', include('mysite.foo.urls')),

    url(r'^$', 'mysite.helloworld.index'),
    url(r'^add/$', 'mysite.add.index'),
    url(r'^list/$', 'mysite.list.index'),
    url(r'^login/$', 'mysite.login.login'),
    url(r'^logout/$', 'mysite.login.logout'),
    url(r'^address/', include('mysite.address.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)
