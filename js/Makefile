# **********************************************************************
#
# Copyright (c) 2003-2015 ZeroC, Inc. All rights reserved.
#
# This copy of Ice is licensed to you under the terms described in the
# ICE_LICENSE file included in this distribution.
#
# **********************************************************************

ifeq ($(NPM),)
NPM = npm
endif

all: npminstall
	$(NPM) run gulp:build

dist: npminstall
	$(NPM) run gulp:dist

clean: npminstall
	$(NPM) run gulp:clean

install: npminstall
	$(NPM) run gulp:install

lint: npminstall
	$(NPM) run gulp:lint

test:
	@python ./allTests.py

npminstall:
	$(NPM) install