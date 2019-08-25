FROM phusion/passenger-ruby26:latest

# Set correct environment variables.
ENV HOME /root
ENV RAILS_ENV "production"
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
ADD ./docker/nginx.conf /etc/nginx/sites-enabled/webapp.conf

# Add startup script to run during container startup
# HOME env var is ignored in phusion baseimage-docker
# - https://github.com/phusion/baseimage-docker#environment-variables
RUN echo /root > /etc/container_environment/HOME
RUN mkdir -p /etc/my_init.d
ADD ./docker/startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/*.sh

# Install yarn
RUN apt update && apt install --no-install-recommends -y curl && \
    curl -o- -L https://yarnpkg.com/install.sh | bash

# Set working directory
RUN mkdir /home/app/webapp
WORKDIR /home/app/webapp/

# Gem caching
COPY Gemfile* ./
RUN gem install bundler && \
    bundle install --jobs 20 --retry 5 --deployment --without development test

# Application setup steps
COPY --chown=app:app . .
RUN bundle exec rake assets:precompile

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*