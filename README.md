# Erlang cluster

## Links

https://stackoverflow.com/questions/45057343/connect-erlang-nodes-on-docker

https://blog.scottlogic.com/2016/01/25/playing-with-docker-compose-and-erlang.html

https://dyp2000.gitbooks.io/russian-armstrong-erlang/content/chapter17.html

https://stackoverflow.com/questions/787755/how-to-add-a-node-to-an-mnesia-cluster

https://stackoverflow.com/questions/13398632/creating-mnesia-disk-copies-of-existing-ram-table

https://www.erlang-solutions.com/blog/running-distributed-erlang-elixir-applications-on-docker.html

https://books.google.ru/books?id=autYAwAAQBAJ&pg=PA287&lpg=PA287&dq=erl+connect_all+false&source=bl&ots=1XirypmbaH&sig=GhA9FzM0twiqZumTWUuuVOxMcUw&hl=ru&sa=X&ved=2ahUKEwj31LTzsOrdAhUxlosKHQL_CWUQ6AEwBHoECAUQAQ#v=onepage&q=nodes()&f=false

## Commands

> docker network create ernet

> docker run -it --rm --name node1 --hostname node1 --net ernet erlang /bin/bash

> erl -sname mnesia -setcookie cookie

> net_adm:ping(mnesia@node2).
