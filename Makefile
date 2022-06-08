tests: \
		test_adhoc_installations \
		test_external_python_packages \
		test_external_r_packages \
		test_internal_python_packages \
		test_os_packages \
		test_os_version \
		test_python_version \
		test_pythontex \
		test_queries \
		test_r_version

SHELL := /bin/bash

.PHONY: \
		clean \
		test_adhoc_installations \
		test_external_python_packages \
		test_external_r_packages \
		test_internal_python_packages \
		test_os_packages \
		test_os_version \
		test_python_version \
		test_pythontex \
		test_queries \
		test_r_version \
		tests

clean:
	rm --force reports/*.aux
	rm --force reports/*.log
	rm --force reports/*.pdf
	rm --force reports/*.pytxcode
	rm --force --recursive reports/pythontex-files-prueba_pythontex

test_external_python_packages:
	@echo "Check Python module versions"
	pip show csvkit | grep "Version: 1."
	pip show goodtables | grep "Version: 2."
	pip show matplotlib | grep "Version: 3."
	pip show numpy | grep "Version: 1."
	pip show pandas | grep "Version: 1."
	pip show pygments | grep "Version: 2."
	pip show scipy | grep "Version: 1."

test_external_r_packages:
	@echo "Check R package versions"
	Rscript -e "packageVersion('covr')" | grep "3\.[0-9]*\.[0-9]*"
	Rscript -e "packageVersion('devtools')" | grep "2\.[0-9]*\.[0-9]*"
	Rscript -e "packageVersion('DT')" | grep "0\.[0-9]*"
	Rscript -e "packageVersion('lintr')" | grep "2\.[0-9]*\.[0-9]*"
	Rscript -e "packageVersion('roxygen2')" | grep "7\.[0-9]*\.[0-9]*"
	Rscript -e "packageVersion('styler')" | grep "1\.[0-9]*\.[0-9]*"
	Rscript -e "packageVersion('tidyverse')" | grep "1\.[0-9]*\.[0-9]*"
	Rscript -e "packageVersion('testthat')"  | grep "3\.[0-9]*\.[0-9]*"
	Rscript -e "packageVersion('vdiffr')" | grep "1\.[0-9]*\.[0-9]*"

test_internal_python_packages:
	@echo "Check GECI module versions"
	pip show bootstrapping-tools | grep "Version: 0."
	pip show descarga-datos | grep "Version: 0."
	pip show geci-cli | grep "Version: 0."
	pip show geci-plots | grep "Version: 0."
	pip show pythontex-tools | grep "Version: 0."

test_os_packages:
	@echo "Check Ubuntu package versions"
	apt-cache policy curl | grep "Installed: 7"
	apt-cache policy docker.io | grep "Installed: 20"
	apt-cache policy gettext-base | grep "Installed: 0"
	apt-cache policy git | grep "Installed: 1:2"
	apt-cache policy gnumeric | grep "Installed: 1"
	apt-cache policy jq | grep "Installed: 1"
	apt-cache policy libcurl4-openssl-dev | grep "Installed: 7"
	apt-cache policy libssl-dev | grep "Installed: 3"
	apt-cache policy libxml2-dev | grep "Installed: 2"
	apt-cache policy make | grep "Installed: 4"
	apt-cache policy openssl | grep "Installed: 3"
	apt-cache policy python3 | grep "Installed: 3"
	apt-cache policy python3-dev | grep "Installed: 3"
	apt-cache policy python3-pip | grep "Installed: 22"
	apt-cache policy texlive-full | grep "Installed: 2021"
	apt-cache policy vim | grep "Installed: 2:8"
	apt-cache policy xml2 | grep "Installed: 0"

test_adhoc_installations:
	@echo "Check ShellSpec version"
	$$HOME/.local/lib/shellspec/bin/shellspec --version | grep "^0"
	shellspec --version | grep "^0"

test_os_version:
	@echo "Check Ubuntu version"
	cat /etc/os-release | grep "Ubuntu 22.04 LTS"

test_python_version:
	@echo "Check Python version"
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
	@echo "Check R version"
	r --version | grep 4.3
