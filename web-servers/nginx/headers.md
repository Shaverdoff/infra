proxy_set_header   X-Real-IP $remote_addr; # Header с адресом клиента
proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for; # Header с адресами proxy и клиента
