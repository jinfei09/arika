from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'csvt02.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    #url(r'^admin/', include(admin.site.urls)),
    url(r'^blog/', 'blog.views.index'),
    url(r'^blog1/', 'blog.views.index1'),
    url(r'^blog2/', 'blog.views.index2'),
)
