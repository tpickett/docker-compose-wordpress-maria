#!/bin/bash
echo "CREATE USER '${DATABASE_USER}'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD}';" | mysql -uroot -p${MYSQL_ROOT_PASSWORD} --host ${MYSQL_PORT_3306_TCP_ADDR} --port=${MYSQL_PORT_3306_TCP_PORT};
echo "GRANT ALL PRIVILEGES ON * . * TO '${DATABASE_USER}'@'localhost';" | mysql -uroot -p${MYSQL_ROOT_PASSWORD} --host ${MYSQL_PORT_3306_TCP_ADDR} --port=${MYSQL_PORT_3306_TCP_PORT};
echo "FLUSH PRIVILEGES" | mysql -uroot -p${MYSQL_ROOT_PASSWORD} --host ${MYSQL_PORT_3306_TCP_ADDR} --port=${MYSQL_PORT_3306_TCP_PORT};
cd ${DATA}
ls -1 *.sql | sed 's/.sql$//' | while read col; do
echo "create database $col" | mysql -uroot -p${MYSQL_ROOT_PASSWORD} --host ${MYSQL_PORT_3306_TCP_ADDR} --port=${MYSQL_PORT_3306_TCP_PORT}
# Insert the backup data
mysql -uroot -p${MYSQL_ROOT_PASSWORD} --host ${MYSQL_PORT_3306_TCP_ADDR} --port=${MYSQL_PORT_3306_TCP_PORT} $col < $col.sql
echo "Database imported: $col"
# Add a kinetic supply admin user
mysql -uroot -p${MYSQL_ROOT_PASSWORD} --host ${MYSQL_PORT_3306_TCP_ADDR} --port=${MYSQL_PORT_3306_TCP_PORT} $col << EOF
INSERT INTO ${WORDPRESS_TABLE_PREFIX}users (ID, user_login, user_pass, user_nicename, user_email, user_url, user_registered, user_activation_key, user_status, display_name) VALUES (587,${WORDPRESS_ADMIN_USER},MD5(${WORDPRESS_ADMIN_PASS}),${WORDPRESS_ADMIN_USER},${WORDPRESS_ADMIN_EMAIL},'', ${date -u +"%Y-%m-%dT%H:%M:%SZ"},'',0,${WORDPRESS_ADMIN_USER});
INSERT INTO ${WORDPRESS_TABLE_PREFIX}usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (NULL, (Select max(id) FROM ${WORDPRESS_TABLE_PREFIX}users), "${WORDPRESS_TABLE_PREFIX}user_level", '10');
INSERT INTO ${WORDPRESS_TABLE_PREFIX}usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (NULL, (Select max(id) FROM ${WORDPRESS_TABLE_PREFIX}users), "${WORDPRESS_TABLE_PREFIX}capabilities", 'a:1:{s:13:"administrator";s:1:"1";}');
UPDATE ${WORDPRESS_TABLE_PREFIX}options SET option_value = 'http://localhost:8080' where option_id = 1;
EOF
echo "Created Wordpress Admin for: $col"
done