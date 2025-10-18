# Use a small nginx base to serve static content
FROM nginx:1.25-alpine
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY app/index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
