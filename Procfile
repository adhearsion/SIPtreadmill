web: bundle exec rails server thin --port $PORT --env $RACK_ENV
worker: bundle exec sidekiq -e $RACK_ENV
