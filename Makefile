.PHONY: install
install: chinesevocablist/*
	# install deps
	pip install -e . --user
	# make chinesevocablist/vocab_list_data.py file
	make chinesevocablist/vocab_list_data.py
	# do install
	python3 setup.py install --user

.PHONY: install_venv
install_venv: chinesevocablist/*
	# install deps
	pip install -e .
	# make chinesevocablist/vocab_list_data.py file
	make chinesevocablist/vocab_list_data.py
	# do install
	python3 setup.py install

.PHONY: publish_test
publish_test: chinesevocablist/vocab_list_data.py
	rm -rf dist
	python3 setup.py sdist bdist_wheel
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*

.PHONY: publish_real
publish_real: chinesevocablist/vocab_list_data.py
	rm -rf dist
	python3 setup.py sdist bdist_wheel
	twine upload dist/*

chinesevocablist/vocab_list_data.py: chinesevocablist/__init__.py \
		chinesevocablist/models.py src/generate_vocab_list_data.py chinese_vocab_list.yaml
	PYTHONPATH="." python3 src/generate_vocab_list_data.py > "$@"

chinese_vocab_list.yaml: src/* reference_files/* contrib_files/* chinesevocablist/__init__.py \
		chinesevocablist/models.py
	$(eval tempfile := $(shell mktemp))
	PYTHONPATH="." python3 src/build_initial_list.py > "${tempfile}"
	cp "${tempfile}" "$@"
