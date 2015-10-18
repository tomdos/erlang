#!/bin/bash

erl -pa ebin -pa deps/piqi/ebin -run test run -s erlang halt
