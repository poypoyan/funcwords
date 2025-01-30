# funcwords
Source code of *Function Words in Philippine Languages* (FWPHL) future website. Stack: Django, MySQL.

## Development and testing with `venv`
Windows
```console
git clone https://github.com/poypoyan/funcwords.git
cd funcwords
python -m venv fwvenv
fwvenv\Scripts\activate
pip install --upgrade -r requirements.txt
```
Type `python` to run Python CLI, and type `deactivate` to exit the environment.

Linux
```console
git clone https://github.com/poypoyan/funcwords.git
cd funcwords
python3 -m venv fwvenv
source fwvenv/bin/activate
pip install --upgrade -r requirements.txt
```
Type `python3` to run Python CLI, and type `deactivate` to exit the environment.

Then read the "Init Steps" [here](<other/django cheatsheet.txt>) to initialize the MySQL server with tables and stuff.

## License
Distributed under the MIT software license. See the accompanying
file LICENSE or https://opensource.org/license/mit/.
