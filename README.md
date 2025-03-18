# funcwords
Source code of *Function Words in Philippine Languages* (FWPHL) future website. Stack: Django, PostgreSQL.

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
Wait a few seconds until the "web-1" container outputs text in terminal. The website will be available at `http://localhost:8000`.

3. Have another terminal tab/window, then run the following commands:
```bash
make makemigrations-fwapp   # run once only. if /fwapp/migrations in container exists already, makemigrations is now enough.
make makemigrations
make migrate
docker exec -i funcwords-db-1 psql -U user0 -d Function_Words < ./other/fwphl_triggers.sql
```

Then to insert sample data:
```bash
docker exec -i funcwords-db-1 psql -U user0 -d Function_Words < ./other/tagalog_personal_pronouns_insert.sql
```

After these, the website should now be populated with data.

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
