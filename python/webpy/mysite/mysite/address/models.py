#coding=utf-8
from django.db import models

# Create your models here.
class Address(models.Model):
        name = models.CharField('Name', max_length=6, unique=True)
        gender = models.CharField('Sex', choices=(('M', 'Male'), ('F', 'Female')), max_length=1)
        telphone = models.CharField('Telphone', max_length=20)
        mobile = models.CharField('Cellphone', max_length=11)
        room = models.CharField('Room', max_length=10)
        def __unicode__(self):
          return self.name

from django.contrib import admin

class AddressAdmin(admin.options.ModelAdmin):
        model=Address
        radio_fields = {'gender':admin.VERTICAL}

admin.site.register(Address,AddressAdmin)