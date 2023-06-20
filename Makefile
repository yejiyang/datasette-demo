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

up: ## Start the container
	docker-compose up -d

down: ## Stop the container
	docker-compose down

logs: ## Show docker container logs
	docker-compose logs -t

#Reference: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
