# Use the mysql image. This way, we already get the mysqldump ready to go.
FROM mysql:5.6

# Install docker-gen in /usr/local/bin
ADD https://github.com/jwilder/docker-gen/releases/download/0.4.0/docker-gen-linux-amd64-0.4.0.tar.gz /root/
RUN cd /root						&& \
    tar xvzf docker-gen-linux-amd64-0.4.0.tar.gz	&& \
    mv docker-gen /usr/local/bin/			&& \
    chmod +x /usr/local/bin/docker-gen			&& \
    rm docker-gen-linux-amd64-0.4.0.tar.gz

# Add the mysql-dumper script and template
ADD mysql-dumper.sh /usr/local/bin/mysql-dumper
ADD mysql-dumper.tpl /usr/local/etc/mysql-dumper.tpl

# Add execution right to the script
RUN chmod +x /usr/local/bin/mysql-dumper

# Register the script as the default command
ENTRYPOINT ["mysql-dumper"]
