.PHONY: help

container_id = $(shell docker ps -lq)
db_name=datasette-demo.db
metadata=metadata.json

step-a-init-env: ## Step 1: install python packages
	poetry install
	poetry shell

step-b-load-csv: ## Step 2: load csv files
	poetry run python src/load_csv.py 

step-c-fix-keys: ## Step 3: fix relationship between tables by adding primary & secondary keys
	sqlite3 $(db_name) < ./src/fix_table_keys.sql

step-d-serve: ## Step 4: serve the database locally
	datasette serve $(db_name) -m $(metadata)

step-e-clear: ## Step 5: clear
	rm $(db_name)

# Works only when run this command in the terminal
# datasette install datasette-auth-passwords
# PASSWORD_HASH_1='pbkdf2_sha256$480000$046b915dc2d3ca3a9fd5aab142a3ffae$/Tp1HGFitqvuJYq/mccWGvmmP2eq9fSJMPGRwHoKyuc=' datasette serve public.db private.db -m metadata.json
server-with-auth-plugin: ## Serve the database with authentication plugin
	echo "run this command in the terminal"
	echo "PASSWORD_HASH_1='pbkdf2_sha256$480000$046b915dc2d3ca3a9fd5aab142a3ffae$/Tp1HGFitqvuJYq/mccWGvmmP2eq9fSJMPGRwHoKyuc=' datasette serve public.db private.db -m metadata.json"

serve-docker: ## Serve the database using docker image
	docker pull datasetteproject/datasette
	docker run -p 8001:8001 -v `pwd`:/mnt datasetteproject/datasette datasette -p 8001 -h 0.0.0.0 /mnt/$(db_name)

serve-docker-graphql: ## Serve the database using docker image with graphql plugin
	docker pull datasetteproject/datasette
	docker run datasetteproject/datasette pip install datasette-graphql
	docker commit $(container_id) datasette-with-plugins
	docker run -p 8001:8001 -v `pwd`:/mnt datasette-with-plugins datasette -p 8001 -h 0.0.0.0 /mnt/$(db_name)

# install Google Cloud CLI: https://cloud.google.com/sdk/docs/install-sdk
gcloud-login:
	gcloud auth login

publish-google-cloud-run: ## Publish to google cloud run 
	gcloud config set project datasette-demo-388909
	gcloud config set run/region europe-north1
	datasette publish cloudrun $(db_name) --service=datasette-demo -m $(metadata)

# Works only when run this command in the terminal
publish-google-cloud-run-password: ## Publish to google cloud run with authentication plugin
	gcloud config set project datasette-demo-388909
	gcloud config set run/region europe-north1
	datasette publish cloudrun public.db private.db --service=datasette-demo -m metadata-publish.json --plugin-secret datasette-auth-passwords root_password_hash 'pbkdf2_sha256$480000$046b915dc2d3ca3a9fd5aab142a3ffae$/Tp1HGFitqvuJYq/mccWGvmmP2eq9fSJMPGRwHoKyuc=' --install datasette-auth-passwords 

up: ## Start the container
	docker-compose up -d

down: ## Stop the container
	docker-compose down

logs: ## Show docker container logs
	docker-compose logs -t

#Reference: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
