# Pull the base image and pre-process it.
FROM python:3.8-slim-buster as base

# Prevent python to create pyc files.
ENV PYTHONWRITEBYTECODE 1

# Disable output buffering.
ENV PYTHONBUFFERED 1

# Update the image, clean and purge.
RUN set -ex \
    && apt-get update \
    && apt-get clean \
    && apt-get purge

# Create new /api directory and set it as work directory.
WORKDIR /api

# Create new user `app` and add it to group `user`.
RUN adduser app

###################
### Build Stage ###
###################

# Use the pre-processed base image.
FROM base AS build

# Copy requirements to install dependencies.
COPY requirements requirements

# Create wheels from requirements for production.
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r requirements/prod.txt

####################
### Deploy Stage####
####################

# Use the pre-processed base image.
FROM base

# Copy the built wheels from Build Stage.
COPY --from=build /wheels /wheels

# Install dependencies from wheels.
RUN pip install --no-cache /wheels/*

# Copy the app code.
COPY . .

# Remove wheels and handle permission issues.
RUN set -ex \
    && rm -r /wheels \
    && chown -R app . \ 
    && chmod +x entrypoint.sh

# Healthcheck by pinging the api.
HEALTHCHECK CMD wget -qO- http://localhost/ping/ || exit 1

# Expose port for gunicorn to listen.
EXPOSE 8000

# Set user to `app` from group `app`.
USER app:app

# Make static dirs to avoid permission conflict
RUN mkdir /api/static/

# Use entrypoint to collect staticfiles before startup.
ENTRYPOINT [ "./entrypoint.sh" ]

# Start gunicorn to startup container.
CMD [ "gunicorn", "--config", "python:gunicorn_config", "config.wsgi" ]
