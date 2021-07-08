tests: \
		test_os_version \
		test_python_modules \
		test_python_version \
		test_pythontex \
		test_queries \
		test_r_version \
		test_tidyverse

SHELL := /bin/bash

.PHONY: \
		clean \
		test_os_version \
		test_python_modules \
		test_python_version \
		test_pythontex \
		test_queries \
		test_r_version \
		test_tidyverse \
		tests

clean:
	rm --force reports/*.aux
	rm --force reports/*.log
	rm --force reports/*.pdf
	rm --force reports/*.pytxcode
	rm --force --recursive reports/pythontex-files-prueba_pythontex

test_os_version:
	cat /etc/os-release | grep "Ubuntu 20.04"

test_python_modules:
	pip freeze | grep bootstrapping_tools
	pip freeze | grep descarga-datos==0.2.1
	pip freeze | grep geci_cli
	pip freeze | grep geci_plots
	pip freeze | grep matplotlib
	pip freeze | grep numpy
	pip freeze | grep pandas
	pip freeze | grep scipy

test_python_version:
	python --version | grep "Python 3.8.5"

test_pythontex: reports/prueba_pythontex.pdf

reports/prueba_pythontex.pdf: reports/prueba_pythontex.tex
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pythontex $(<F)
	cd $(<D) && pdflatex $(<F)

test_queries:
	[ $$(tail -1 tests/data/test.csv | cut --characters=1-11) == "01/Dic/2019" ] && \
    [ $$(cambia_formato_fecha tests/data/test.csv | tail -1 | cut --characters=1-10) == "2019-12-01" ]

test_r_version:
	r --version | grep 4.0.5

test_tidyverse:
	Rscript -e "library('tidyverse')"
