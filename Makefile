tests: \
		test_external_python_modules \
		test_internal_python_modules \
		test_os_version \
		test_python_version \
		test_pythontex \
		test_queries \
		test_r_version \
		test_tidyverse

SHELL := /bin/bash

.PHONY: \
		clean \
		test_external_python_modules \
		test_internal_python_modules \
		test_os_version \
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
	cat /etc/os-release | grep "Ubuntu 22.04 LTS"

test_external_python_modules:
	pip show csvkit | grep "Version: 1."
	pip show goodtables | grep "Version: 2."
	pip show matplotlib | grep "Version: 3."
	pip show numpy | grep "Version: 1."
	pip show pandas | grep "Version: 1."
	pip show pygments | grep "Version: 2."
	pip show scipy | grep "Version: 1."

test_internal_python_modules:
	pip show bootstrapping-tools | grep "Version: 0."
	pip show descarga-datos | grep "Version: 0."
	pip show geci-cli | grep "Version: 0."
	pip show geci-plots | grep "Version: 0."
	pip show pythontex-tools | grep "Version: 0."

test_python_version:
	python --version | grep "Python 3.10"

test_pythontex: reports/prueba_pythontex.pdf

reports/prueba_pythontex.pdf: reports/prueba_pythontex.tex
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pythontex $(<F)
	cd $(<D) && pdflatex $(<F)

test_queries:
	[ $$(tail -1 tests/data/test.csv | cut --characters=1-11) == "01/Dic/2019" ] && \
    [ $$(cambia_formato_fecha tests/data/test.csv | tail -1 | cut --characters=1-10) == "2019-12-01" ]

test_r_version:
	r --version | grep 4.3

test_external_r_modules:
	Rscript -e "packageVersion('tidyverse')" | grep "1\.[0-9]*\.[0-9]*"
	Rscript -e "packageVersion('testthat')"  | grep "3\.[0-9]*\.[0-9]*"
	
