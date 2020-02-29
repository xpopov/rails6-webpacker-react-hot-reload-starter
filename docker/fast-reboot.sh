. ./docker/run-env.sh
docker-compose -f docker-compose.prod.yml exec app bash -c "pkill -f puma; pkill -f rails"
sleep 5
docker-compose -f docker-compose.prod.yml exec app nohup rails s -b 'ssl://0.0.0.0:443?verify_mode=none&key=./docker/certs/key.pem&cert=./docker/certs/cert.pem' &> log/server-runner.log & sleep 1
