FROM registry.gitlab.tpwd.de/cmmc-systems/ruby-nginx/ruby-3.0.0

RUN apk add dcron

RUN mkdir -p /unicorn
RUN mkdir -p /app
WORKDIR /app

# nginx default
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY docker/unicorn.rb /app/config/unicorn.rb
COPY docker/database.yml /app/config/database.yml


COPY . .

RUN bundle install --without development test
RUN yarn install
RUN bundle exec rake DATABASE_URL=nulldb://user:pass@127.0.0.1/dbname assets:precompile


ENTRYPOINT ["/app/docker/entrypoint.sh"]

CMD ["sh", "-c", "nginx-debug ; bundle exec unicorn -c config/unicorn.rb"]
