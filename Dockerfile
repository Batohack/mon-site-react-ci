# Étape 1 : Build React
FROM node:20-alpine as build
WORKDIR /app
COPY app/package*.json ./
RUN npm install
COPY app/ .
ARG GIT_COMMIT=unknown
ENV REACT_APP_GIT_COMMIT=$GIT_COMMIT
RUN npm run build

# Étape 2 : Servir avec Nginx
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
