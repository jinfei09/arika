from django import forms

class ScgForm(forms.Form):
    name = forms.CharField()
    itcode = forms.CharField()
    message = forms.CharField(required=False)

