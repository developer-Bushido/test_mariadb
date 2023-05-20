---
all:
  children:
    orschestrators:
      hosts:
%{ for ip in orchestrator_ips ~}
        ${ip}:
%{ endfor ~}
    proxysql:
      hosts:
%{ for ip in proxysql_ips ~}
        ${ip}:
%{ endfor ~}
    mariadb:
      hosts:
%{ for ip in mariadb_ips ~}
        ${ip}:
%{ endfor ~}
