FROM erlang:latest
COPY app_mnesia.erl app_mnesia.erl
RUN erlc app_mnesia.erl
ENTRYPOINT ["erl", "-noshell", "-sname", "mnesia", "-setcookie", "cookie", "-run", "app_mnesia", "start"]

