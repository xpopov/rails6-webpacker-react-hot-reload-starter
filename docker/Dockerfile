FROM ruby:2.6.3

#    postgresql-client
# rm -rf /var/lib/apt/lists

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -

# Install pg 12 client
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |tee  /etc/apt/sources.list.d/pgdg.list

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install eventually
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends apt-utils lsb-release net-tools nano telnet nodejs postgresql-client-12 yarn

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install

# Build assets in public, as well as node_modules
COPY package.json ./
# COPY app/javascript/* ./app/javascript
RUN yarn install --check-files
# COPY package-lock.json ./
# RUN npm install
# RUN echo "NPM packages installed!"

COPY app/javascript ./app/javascript
COPY app/assets ./app/assets
# RUN mkdir public && echo "." > public/.need_compilation
# RUN RAILS_ENV=staging rails assets:precompile

COPY . .

# RUN RAILS_ENV=staging rails db:setup

# 3000 for debugging
EXPOSE 3000
EXPOSE 443
EXPOSE 80
# CMD sleep infinity
# CMD rails s -b 0.0.0.0
CMD rails s -b 'ssl://0.0.0.0:443?verify_mode=none&key=./docker/certs/key.pem&cert=./docker/certs/cert.pem'; sleep infinity
