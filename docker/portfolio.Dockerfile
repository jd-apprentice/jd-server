FROM node:20.9.0-alpine3.18

WORKDIR /app

RUN npm install -g http-server

EXPOSE 3500

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

CMD ["http-server", "./data", "-p", "3500"]
