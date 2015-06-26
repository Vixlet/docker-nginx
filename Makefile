all:
	docker build -f Dockerfile -t vixlet/nginx .

clean:
	docker rmi -f vixlet/nginx

test:
	bash -c 'make example-stop 2>/dev/null; echo "cleaned up from prior tests"'
	make clean
	make
	make example-run
	sleep 2
	make example-status
	make example-stop
	echo "passed test!"

example-status:
	bash -c 'docker ps | grep vixlet-nginx-example >/dev/null 2>&1'

example-run:
	docker run -d -p 49980:80 -v $( pwd )/example-site:/var/app -v $( pwd )/example-site/conf.d:/etc/nginx/conf.d --name "vixlet-nginx-example" vixlet/nginx:latest

example-stop:
	docker stop vixlet-nginx-example
	docker rm vixlet-nginx-example

publish:
	docker push vixlet/nginx
