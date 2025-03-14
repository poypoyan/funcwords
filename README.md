# funcwords
Source code of *Function Words in Philippine Languages* (FWPHL) future website. Stack: Django, MySQL.

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
make makemigrations-fwapp   # run once only. if /fwapp/migrations exists already, makemigrations is now enough.
make makemigrations
make migrate
source .env_mysql
docker exec -i funcwords-db-1 mysql -u root -p"$MYSQL_ROOT_PASSWORD" < ./other/fwphl_triggers.sql
```

Then to insert sample data:
```bash
docker exec -i funcwords-db-1 mysql --default-character-set=utf8 -u root -p"$MYSQL_ROOT_PASSWORD" < ./other/tagalog_personal_pronouns_insert.sql
```

After these, the website should now be populated with data.

## Extra Stuff
* We provide a Makefile for common commands for development.
* Docker Shell:
```bash
make shell
```

* MySQL Command Line (requires typing root password):
```bash
docker exec -it funcwords-db-1 mysql -u root -p
```

* Lastly, you may take a look at my [Django cheatcheet](<other/django cheatsheet.txt>).

## License
Distributed under the MIT software license. See the accompanying
file LICENSE or https://opensource.org/license/mit/.
