all: clean install test

install:
	pip install -e .
	pip install twine coverage nose moto pytest pytest-cov black flake8 isort bump2version mypy ipdb

test: install
	rm -rf ./cache.db*
	pytest tests -s --cov=ftm_geocode --cov-report term-missing
	rm -rf ./cache.db*

typecheck:
	mypy --strict ftm_geocode

build:
	python setup.py sdist bdist_wheel

release: clean build
	twine upload dist/*

clean:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

data/NUTS_RG_01M_2021_4326.shp.zip:
	wget -4 -O data/NUTS_RG_01M_2021_4326.shp.zip https://gisco-services.ec.europa.eu/distribution/v2/nuts/shp/NUTS_RG_01M_2021_4326.shp.zip
