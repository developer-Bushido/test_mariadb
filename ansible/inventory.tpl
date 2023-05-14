---
all:
  children:
    web:
      hosts:
        ${web_ip}:
    db:
      children:
        master_db:
          hosts:
%{ for ip in master_ips ~}
            ${ip}:
%{ endfor ~}
        slave_db:
          hosts:
%{ for ip in slave_ips ~}
            ${ip}:
%{ endfor ~}
