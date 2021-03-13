SRCIMG=httpd
SVC = web
CNTR = flask
CNTSHELL=bash
HOSTFLDR=/srv/storage/projects/websites/flask

hostinfra:
	@[ ! -d $(HOSTFLDR) ] && mkdir $(HOSTFLDR) || true

deploy: Dockerfile docker-compose.yml hostinfra
	@docker-compose up -d

debug: Dockerfile docker-compose.yml hostinfra
	@docker-compose up

reload:
	@touch $(HOSTFLDR)/flaskapp.wsgi

shell:
	@docker exec -it $(CNTR) $(CNTSHELL)

app:
	@docker exec -it $(APP)

clean:
	@docker stop $(CNTR)
	@docker rm $(CNTR)
	@docker image rm $(CNTR)_$(SVC)

inter:
	@../scripts/clean_intermediates

extract:
	@docker run --rm $(SRCIMG) cat /usr/local/apache2/conf/httpd.conf > my-httpd.conf

actions:
	@echo "deploy\t\t\t\t\tStart Container detached"
	@echo "debug\t\t\t\t\tStart container interactively"
	@echo "shell\t\t\t\t\tStart interactive bash in container, use CNTSHELL env for a different shell"
	@echo "app APP='app'\t\t\t\tRun the given 'app' interactively in the container"
	@echo "clean\t\t\t\t\tAs best can be done, clean up related containers and images"
	@echo "inter\t\t\t\t\tCall clean intermediates script"
	@echo "extract [path_to_file] [output_name]\tExtract file from image to given name"
