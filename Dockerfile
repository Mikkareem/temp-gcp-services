FROM node:24-slim
WORKDIR /tmp
COPY ./app/server.js ./
EXPOSE 8080
CMD [ "node", "server.js" ]
