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
${master_ips}
        slave_db:
          hosts:
${slave_ips}
