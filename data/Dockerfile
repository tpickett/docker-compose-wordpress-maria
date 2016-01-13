FROM mariadb
ENV DATA /usr/local/src/restore/backups
RUN mkdir /usr/local/src/restore
ADD ./ /usr/local/src/restore/
RUN chmod +x /usr/local/src/restore/startup.sh
WORKDIR /usr/local/src/restore
ENTRYPOINT /usr/local/src/restore/startup.sh