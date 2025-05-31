# funcwords
Function Words in Philippine Languages. Stack: Django, PostgreSQL. Now production ready with Gunicorn and Nginx.

## Docker Setup
1. Make sure you have Docker and Make installed.
2. Run the following commands:
```bash
# Build and start the application
make build
make up

# Or start in detached mode (e.g., in production)
make up-d
```
Then `http://localhost` should now work, but without any "design" because static files like CSS are not loaded yet.

3. Have another terminal tab/window, then run the following commands:
```bash
make makemigrations-fwapp   # run this once only. afterwards, run 'make makemigrations' instead.
make migrate
make static
# replace "funcwords" with the name of directory where this is located
docker exec -i funcwords-db-1 psql -U user0 -d Function_Words < ./other/fwphl_triggers.sql
docker exec -i funcwords-db-1 psql -U user0 -d Function_Words < ./other/0_tagalog_personal_pronouns.sql   # initial data
```

## A Production Experience
1. Grind to have some money (😫) to buy a VPS (ideally Ubuntu with Docker installed) and a domain. Then follow the steps provided by the VPS provider to connect the two.
2. Modify `.env` with secure values. Set `DEBUG` to False and `DJANGO_ALLOWED_HOSTS` to your domain with dot in the beginning, like `.example.com`. Replace every instance of `example.com` in this repo with your domain.
3. Uncomment the `.env` in `.gitignore`. Do NOT upload prod environment variables anywhere!
4. Copy files from local to VPS using rsync:
```bash
rsync -avz . root@<VPS IP address>:~/the-app --exclude .git/
```
This assumes that the current directory of terminal is this repo. Note that `the-app` directory will be created in the home directory (~) of the user (root in the case of the command above) in VPS, and the files will be copied to that directory.

5. SSH to your VPS: `ssh root@<VPS IP address>`. After login, you'll be in home directory. Go to `the-app` directory and do the Docker setup above. Website should now be up! But it's in HTTP.
6. HTTP Secure (HTTPS) configuration in `docker-compose.yml`, `settings.py`, and `nginx.conf` are commented. Follow [this](https://certbot.eff.org/instructions?ws=nginx&os=snap) to create SSL certificate except do
```bash
sudo certbot certonly --webroot -w /var/www/certbot/ -d example.com
```
for getting the certificate. Through webroot, certbot can automatically renew without needing to stop containers.

**Update:** I now prefer [this setup](other/decouple-nginx.md), with changes before and during Step 5.

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

## License
Distributed under the MIT software license. See the accompanying
file LICENSE or https://opensource.org/license/mit/.