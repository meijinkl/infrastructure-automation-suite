FROM nginx:1.27-alpine

RUN sed -i 's/^user nginx;/#user nginx;/' /etc/nginx/nginx.conf

RUN sed -i 's|pid /var/run/nginx.pid;|pid /tmp/nginx.pid;|' /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY certs/server.crt /etc/nginx/certs/server.crt
COPY certs/server.key /etc/nginx/certs/server.key

RUN chown -R nginx:nginx /etc/nginx/certs /var/cache/nginx /var/log/nginx /tmp

USER nginx

EXPOSE 8080 8443

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider --no-check-certificate https://localhost:8443/ || exit 1

CMD ["nginx", "-g", "daemon off;"]