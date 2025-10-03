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

## Data Dump and Migration
1. In a source repository (e.g., `ssh` to production in VPS), run this command to dump all data:
```bash
docker exec -i <src repo dir name>-web-1 python manage.py dumpdata fwapp > <some dir path>/db.json
```
2. Exit the VPS. Go (`cd`) to a local directory and run `rsync` to copy the dump to local:
```bash
rsync -avz root@<VPS IP address>:<some dir path>/db.json .
```
3. Now `db.json` is in the local directory. Copy it to the mount directory inside a destination repository. Finally, `cd` to the repository and run this command to upload the dump:
```bash
docker exec -i <dest repo dir name>-web-1 python manage.py loaddata mount/db.json
```