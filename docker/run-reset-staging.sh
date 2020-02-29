. ./docker/run-env.sh
# cd ..
docker-compose -f docker-compose.prod.yml  down
docker-compose -f docker-compose.prod.yml up --build -d app
sleep 5
docker-compose -f docker-compose.prod.yml exec app bash -c "pkill -f puma; pkill -f rails"
docker-compose -f docker-compose.prod.yml exec app bash -c "nohup ./bin/sidekiq.sh &> log/sidekiq-runner.log & sleep 1"
docker-compose -f docker-compose.prod.yml exec app bash -c "rails db:migrate"
docker-compose -f docker-compose.prod.yml exec app bash -c "rails assets:precompile"

sleep 10
# should not create local process, but instead inside container
docker-compose -f docker-compose.prod.yml exec app nohup rails s -b 'ssl://0.0.0.0:443?verify_mode=none&key=./docker/certs/key.pem&cert=./docker/certs/cert.pem' &> log/server-runner.log & sleep 1
