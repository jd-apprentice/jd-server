FROM node:20.9.0-alpine3.18

WORKDIR /app

RUN npm install -g http-server

EXPOSE 3500

CMD ["http-server", "./data", "-p", "3500"]
