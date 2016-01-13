# docker-compose-wordpress-maria

Docker development environment for working with WordPress applications with the ability to preload Database with MySql .sql backup file.


## Quickstart
### docker-compose
update the docker-compose file with the path of your wordpress folder:
```
wordpress:
  image: wordpress
  hostname: wordpress
  links:
    - wordpress_db:mysql
  ports:
    - 8080:80
  volumes:
    - ./WORDPRESS_DIR:/var/www/html
...
```
run the container with compose:
```
docker-compose up
```

### loading a backed up database
Put your ".sql" backup in the "data/backups" folder. Create it if it doesn't exist.
```
mkdir PATH/TO/CLONED/REPO/data/backups
```
uncomment the "data" container in the docker-compose.yaml file:
```
data:
...
  build: ./data
  environment:
    MYSQL_ROOT_PASSWORD: examplepass
    DATABASE_USER: exampleuser
    DATABASE_PASSWORD: passwordexample
    WORDPRESS_TABLE_PREFIX: wp_
    WORDPRESS_ADMIN_USER: test
    WORDPRESS_ADMIN_PASS: testexample
    WORDPRESS_ADMIN_EMAIL: test@test.com
  links:
    - wordpress_db:mysql
```
run containers with compose:
```
docker-compose up
```