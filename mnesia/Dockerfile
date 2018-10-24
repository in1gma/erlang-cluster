FROM erlang:latest
WORKDIR /app
COPY src .
RUN erlc app_mnesia.erl
ENTRYPOINT ["erl", "-noshell", "-sname", "mnesia", "-setcookie", "cookie"]
