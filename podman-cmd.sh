#!/bin/bash

DINAME="docker.io/library/haproxy:latest"
DCNAME="haproxy"
HOSTNAME="haproxy.mynet.lan"

NO_ARGS=0
E_OPTERR=65

if [ $# -eq "$NO_ARGS" ]
then
  printf "Отсутствуют аргументы. Должен быть хотя бы один аргумент.\n"
  printf "Использование: $0 {-build|-rmi|-none|-rmfa|-run|-restart|-rmf|-exec|-exec0|-logsf}\n"
  printf " $0 -run - создание и запуск контейнера $DCNAME\n" 
  printf " $0 -restart - перезапуск контейнера $DCNAME\n"
  printf " $0 -rmf - удаление контейнера $DCNAME (docker rm -f $DCNAME)\n"
  printf " $0 -rmfa - удаление всех контейнеров, в том числе и запущенных (docker rm -f \$(dokcer ps -a -q)\n"
  printf " $0 -exec - подключиться к контейнеру $DCNAME (docker exec -it $DCNAME /bin/bash)\n"
  printf " $0 -exec0 - подключиться к контейнеру $DCNAME из-под пользователя uid 0 (docker exec -it -u 0 $DCNAME /bin/bash)\n"
  printf " $0 -logsf - вывод служебных сообщений контейнера $DCNAME (docker logs -f $DCNAME)\n"
  printf " $0 -build - сборка образа $DINAME\n"
  printf " $0 -rmi - удаление образа $DINAME\n"
  printf " $0 -none - удаление образов NONE\n"
  exit $E_OPTERR
fi

while :; do
	case "$1" in
	-run)
	  podman run --name $DCNAME -dt \
	  --dns 192.168.88.2 \
	  -v $PWD/volumes/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg \
	  -p 80:80 \
	  -h $HOSTNAME \
	  $DINAME
	 ;;
	-restart)
	  podman restart $DCNAME
	 ;;
	-rmf)
	  podman rm -f $DCNAME
	 ;;
	-exec)
	  podman exec -it $DCNAME /bin/bash
	 ;;
	-exec0)
	  podman exec -it -u 0 $DCNAME /bin/bash
	 ;;
	-logsf)
	  podman logs -f $DCNAME
	 ;;
	--)
	  shift
	 ;;
	?* | -?*)
	  printf 'ПРЕДУПРЕЖДЕНИЕ: Неизвестный аргумент (проигнорировано): %s\n' "$1" >&2
	 ;;
	*)
	  break
	esac
	shift
done

exit 0
