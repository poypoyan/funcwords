# Volume Mount

## Setup
1. The "mount" directory is already provided for this. Just add your scripts and other files there and you're ready to go!
2. Python scripts can be directly executed through this command:
```bash
docker exec -it funcwords-web-1 python mount/your-script.py
```

## Access Django ORM
To access Django models, put the following snippet at the top part of your Python script:
```python
import sys, os, django
sys.path.append("/app/")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "fwphl.settings") 
django.setup()
```
Then import models like this:
```python
from fwapp.models import Term
```