all: build

build:
	python -m urubu build
	touch _build/.nojekyll

serve:
	python -m urubu serve

publish:
	rsync -vrlu --rsh=ssh _build/*  lampiao:/var/vhost/openpower
