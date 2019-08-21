FROM phusion/passenger-ruby26

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Enable nginx and passenger which is disabled by default
RUN rm -f /etc/service/nginx/down

# Add NGINX configuration file
RUN rm /etc/nginx/sites-enabled/default
ADD ./docker/nginx.conf /etc/nginx/sites-enabled/webapp.conf

# Add the rails-env configuration file so Nginx preserves the environment variables listed
ADD ./docker/rails-env.conf /etc/nginx/main.d/rails-env.conf

# Add startup script to run during container startup
RUN mkdir -p /etc/my_init.d
ADD ./docker/startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/*.sh

RUN mkdir /home/app/webapp
COPY --chown=app:app . /home/app/webapp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install necessary packages
RUN apt update && apt install --no-install-recommends -y curl wget
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

ENV PATH "$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
ENV RAILS_ENV "production"
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Sets the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow it
WORKDIR /home/app/webapp/

RUN gem install bundler
RUN bundle install --deployment --without development test
RUN bundle exec rails webpacker:install
RUN echo "Something"
# RUN bundle exec rake assets:precompile