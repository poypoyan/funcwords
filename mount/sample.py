import sys, os, django
sys.path.append("/app/")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "fwphl.settings") 
django.setup()

from fwapp.models import Term

print('If there are no error messages, then accessing Django ORM works!')