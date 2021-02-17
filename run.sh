#!/bin/sh

./mvnw package

if [ "S1" = "--dry-run" ]; then
  exit
fi

docker network create broker-network || true

docker container rm -f zookeeper-container
docker container rm -f kafka-container

PORT=9092

docker run -d --network broker-network --name zookeeper-container --expose "$PORT" -e ZOOKEEPER_CLIENT_PORT="2181" -e ALLOW_ANONYMOUS_LOGIN="true" bitnami/zookeeper
docker run -d --network broker-network --name kafka-container --expose "$PORT" -e KAFKA_BROKER_ID="1" -e KAFKA_LISTENERS="PLAINTEXT://:9092" -e KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://kafka-container:9092" -e KAFKA_ZOOKEEPER_CONNECT="zookeeper-container:2181" -e ALLOW_PLAINTEXT_LISTENER="true" bitnami/kafka