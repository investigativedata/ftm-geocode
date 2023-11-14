all: clean install test

install:
	poetry install --with dev

lint:
	poetry run flake8 ftm_geocode --count --select=E9,F63,F7,F82 --show-source --statistics
	poetry run flake8 ftm_geocode --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

pre-commit:
	poetry run pre-commit install
	poetry run pre-commit run -a

typecheck:
	poetry run mypy --strict ftm_geocode

test:
	poetry run pytest -v --capture=sys --cov=ftm_geocode --cov-report term-missing

build:
	poetry run build

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
