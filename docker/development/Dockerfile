FROM phusion/passenger-ruby26:latest

# Set correct environment variables.
ENV HOME /root
ENV RAILS_ENV "development"
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH "$BUNDLE_BIN:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Expose Nginx HTTP service
EXPOSE 80

# Enable nginx and passenger which is disabled by default
RUN rm -f /etc/service/nginx/down

# Add NGINX configuration file
RUN rm /etc/nginx/sites-enabled/default
ADD ./docker/development/nginx.conf /etc/nginx/sites-enabled/webapp.conf

# Add the env configuration file so Nginx preserves the environment variables listed
# Reference: https://github.com/phusion/passenger-docker#setting-environment-variables-in-nginx
# ADD ./docker/development/env.conf /etc/nginx/main.d/env.conf

# Install yarn
RUN apt update && apt install --no-install-recommends -y curl && \
    curl -o- -L https://yarnpkg.com/install.sh | bash

# Set working directory
RUN mkdir /home/app/webapp
WORKDIR /home/app/webapp/

# Gem caching
COPY Gemfile* ./
RUN gem install bundler && \
    bundle install --jobs 20 --retry 5

# Application setup steps
COPY --chown=app:app . .

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*