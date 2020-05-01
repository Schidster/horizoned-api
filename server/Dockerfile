# The base image to build upon.
FROM nginx:1.17.4-alpine

#  Remove default configurations.
RUN rm /etc/nginx/conf.d/default.conf

# Set server configurations.
COPY nginx.conf /etc/nginx/conf.d/nginx.conf

# Set robots.txt for web-crawlers.
COPY robots.txt /api/robots.txt
