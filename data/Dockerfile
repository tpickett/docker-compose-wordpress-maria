FROM mariadb
ADD ./startup.sh /tmp/
RUN chmod +x /tmp/startup.sh
RUN /tmp/startup.sh
RUN rm /tmp/startup.sh