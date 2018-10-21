FROM debian:stretch

RUN apt-get update -y
RUN apt-get -y install git wget curl gcc make inotify-tools gnupg
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb

RUN wget https://packages.erlang-solutions.com/debian/erlang_solutions.asc
RUN apt-key add erlang_solutions.asc
RUN apt-get update -y
RUN apt-get -y install erlang-base-hipe erlang erlang-dev erlang-manpages erlang-mode

WORKDIR /app
COPY src .

RUN ./mad deps
RUN ./mad compile plan

CMD ./mad repl
