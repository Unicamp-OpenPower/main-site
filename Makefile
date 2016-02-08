all: build

build:
	python -m urubu build
	touch _build/.nojekyll

serve:
	python -m urubu serve

publish:
	cp -R _build/* /var/vhost/openpower    
