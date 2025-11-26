.PHONY: setup-unit-tests run-unit-tests setup-functional-tests run-functional-tests run-nats

COMPOSE_FILE = tests/nats/docker-compose.yaml
SERVICE = nats

run-nats:
	docker compose -f $(COMPOSE_FILE) up --wait

stop-nats:
	docker compose -f $(COMPOSE_FILE) down -v

setup-unit-tests:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) sh -c "cd /library && composer install --prefer-dist --no-progress --no-suggest"

run-unit-tests:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) sh -c "cd /library && XDEBUG_MODE=coverage ./vendor/bin/phpunit --configuration phpunit.xml.dist --coverage-clover clover.xml --coverage-text --colors=never"

setup-functional-tests:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) sh -c "cd /library/tests/functional && composer install --prefer-dist --no-progress --no-suggest"

run-functional-tests:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) sh -c "cd /library/tests/functional && vendor/bin/behat"

