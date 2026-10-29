FROM nginx:1.27-alpine

RUN sed -i 's|pid        /var/run/nginx.pid;|pid        /tmp/nginx.pid;|' /etc/nginx/nginx.conf && \
    sed -i 's/^user  nginx;/#user  nginx;/' /etc/nginx/nginx.conf

RUN chown -R nginx:nginx /var/cache/nginx /var/log/nginx

COPY --chown=nginx:nginx nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=nginx:nginx certs/server.crt /etc/nginx/certs/server.crt
COPY --chown=nginx:nginx certs/server.key /etc/nginx/certs/server.key

USER nginx

ENTRYPOINT ["nginx", "-g", "daemon off;"]

EXPOSE 8080 8443

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider --no-check-certificate https://localhost:8443/ || exit 1