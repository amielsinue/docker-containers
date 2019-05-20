FROM mdillon/postgis:9.6
RUN apt-get update
RUN apt-get install git gcc make postgresql-server-dev-9.6 -y && git config --global http.sslVerify false
RUN git clone https://github.com/eulerto/wal2json.git && cd wal2json && USE_PGXS=1 make && USE_PGXS=1 make install
RUN sed -i 's/#max_replication_slots = 0/max_replication_slots = 1/' /usr/share/postgresql/postgresql.conf.sample && sed -i 's/#wal_level = minimal/wal_level = logical/' /usr/share/postgresql/postgresql.conf.sample
RUN service postgresql restart
