SHELL := /bin/bash

tests: test_os test_python test_python_modules test_pythontex test_queries test_tidyverse

.PHONY: clean tests test_os test_python test_python_modules test_pythontex test_queries test_tidyverse

test_os:
	cat /etc/os-release | grep "Ubuntu 21.04 LTS"

test_python:
	[ "$$(python --version | cut --characters=1-8)" == "Python 3" ]

test_python_modules:
	pip freeze | grep descarga-datos
	pip freeze | grep matplotlib
	pip freeze | grep numpy
	pip freeze | grep pandas

test_pythontex: reports/prueba_pythontex.pdf

reports/prueba_pythontex.pdf: reports/prueba_pythontex.tex
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pythontex $(<F)
	cd $(<D) && pdflatex $(<F)

test_queries:
	[ $$(tail -1 tests/data/test.csv | cut --characters=1-11) == "01/Dic/2019" ] && \
    [ $$(cambia_formato_fecha tests/data/test.csv | tail -1 | cut --characters=1-10) == "2019-12-01" ]

test_tidyverse:
	Rscript -e "library('tidyverse')"

clean:
	rm --force reports/*.aux
	rm --force reports/*.log
	rm --force reports/*.pdf
	rm --force reports/*.pytxcode
