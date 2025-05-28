# Decouple Nginx
You may want to do this if you'll deploy multiple containers in one VPS. This assumes an Ubuntu VPS.

## Code Changes
1. In `docker-compose.yml`, comment out the whole nginx section and the `static_vol` in volumes section. Change the expose and volume subsection of web section to:
```yaml
    ports:
      - "127.0.0.1:8000:8000"
    volumes:
      - ./static:/app/static
```
Through the new volumes setting, a `static` directory will be created inside `the-app`.

2. In `nginx.conf`, replace the `alias` of `location /static/` to `<absolute path of the-app>/static/;` (pwd command helps here) and the `proxy_pass` of `location /` to `http://localhost:8000;`. Most likely the nginx version is older, so revert the http2 setting to the old style: set `listen 443 ssl http;` and comment out `http2 on;`.

3. Copy files to VPS using rsync.

## SSH Setup
1. After login, install nginx:
```bash
sudo apt update
sudo apt install nginx
```
2. Setup firewall:
```bash
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw enable
```
3. Go to `the-app` directory and put the nginx config file to the actual config directory.
```bash
cp ./nginx/nginx.conf /etc/nginx/conf.d/
```
4. Remove the default in `sites-enabled` directory and then run nginx:
```bash
unlink /etc/nginx/sites-enabled/default
systemctl start nginx
```
5. Do the Docker setup.