all: image

image:
	docker build -t elcamlost/check_mk .
