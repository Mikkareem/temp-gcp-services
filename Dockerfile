FROM node:24-slim
COPY ./app /app
EXPOSE 8080
CMD [ "node /app/server" ]