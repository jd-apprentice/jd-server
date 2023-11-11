FROM node:20.9.0-alpine3.18

WORKDIR /app

RUN npm install -g serve

EXPOSE 3000

CMD ["serve", "-s", "page", "-l", "3000"]
