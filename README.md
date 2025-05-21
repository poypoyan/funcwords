# funcwords
Function Words in Philippine Languages (FWPHL). Stack: Django, PostgreSQL.

## Docker Setup
1. Make sure you have Docker and Make installed.
2. Run the following commands:
```bash
# Build and start the application
make build
make up

# Or start in detached mode
make up-d
```
Then `http://localhost:8000` should now work.

3. Have another terminal tab/window, then run the following commands:
```bash
make makemigrations-fwapp   # run this once only. afterwards, run 'make makemigrations' instead.
make migrate
docker exec -i funcwords-db-1 psql -U user0 -d Function_Words < ./other/fwphl_triggers.sql
```

4. (Optional but recommended) To insert sample data:
```bash
docker exec -i funcwords-db-1 psql -U user0 -d Function_Words < ./other/tagalog_personal_pronouns_insert.sql
```
Then it is now populated with data.

## Extra Stuff
* We provide a Makefile for common commands for development.
* Docker Shell:
```bash
make shell
```

* PostgreSQL Command Line:
```bash
docker exec -it funcwords-db-1 psql -d Function_Words -U user0
```

* Lastly, you may take a look at my [Django cheatsheet](<other/django cheatsheet.txt>).

## License
Distributed under the MIT software license. See the accompanying
file LICENSE or https://opensource.org/license/mit/.
