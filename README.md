# license_website
Website for license_auto application

# Usage
1. Configure the website with the file `license_website/config/supervisord.ini` in the [includes] list of supervisord.conf of
  your server first,
2. Reload supervisord configure file with `# supervisorctl reload`
3. Start the website with `# supervisorctl start website`
4. Open browser URL [http://your_server_host:3000/](http://your_server_host:3000/)