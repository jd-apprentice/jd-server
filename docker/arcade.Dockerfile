FROM node:20.9.0-alpine3.18

WORKDIR /app

RUN npm install -g serve

EXPOSE 3000

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

CMD ["serve", "-s", "page", "-l", "3000"]
