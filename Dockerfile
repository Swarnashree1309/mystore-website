FROM nginx:alpine

COPY Mystore/ /usr/share/nginx/html/

EXPOSE 80

