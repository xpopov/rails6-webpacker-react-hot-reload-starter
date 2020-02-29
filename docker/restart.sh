. ./docker/run-env.sh
docker-compose -f docker-compose.prod.yml build app
docker-compose -f docker-compose.prod.yml stop app
sleep 1
docker-compose -f docker-compose.prod.yml up -d app
sleep 5
docker-compose -f docker-compose.prod.yml exec app bash -c "nohup ./bin/sidekiq.sh &> log/sidekiq-runner.log & sleep 1"
# docker-compose -f docker-compose.prod.yml exec app "nohup bundle exec sidekiq -e staging -C config/sidekiq.yml -- &"

# docker-compose -f docker-compose.prod.yml exec app bash -c "rails assets:precompile"
