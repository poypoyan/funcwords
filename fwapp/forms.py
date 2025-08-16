from django import forms


class SearchForm(forms.Form):
    template_name = "form_search.html"

    _TYPES = (('term', 'Term'), ('language', 'Language'), ('category', 'Category'))

    q = forms.CharField(max_length=100, required=True, label='')
    t = forms.ChoiceField(choices=_TYPES, initial='term', label='')