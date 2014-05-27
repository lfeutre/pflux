LFE_PATH=$(SCRIPT_PATH):./deps/lfe/bin
ERL_LIBS=$(shell lfetool info erllibs)

pflux-dev:
	@echo "Running OTP app in the foreground ..."
	@ERL_LIBS=$(ERL_LIBS) PATH=$(LFE_PATH) lfe \
	-eval "'pflux-app':start()" -noshell

pflux-run: pflux-dev

pflux-prod:
	@echo "Running OTP app in the background ..."
	@ERL_LIBS=$(ERL_LIBS) PATH=$(LFE_PATH) lfe \
	-eval "'pflux-app':start()" \
	-name pflux@$${HOSTNAME} -setcookie `cat ~/.erlang.cookie` \
	-noshell -detached

pflux-daemon: pflux-prod


pflux-stop:
	@ERL_LIBS=$(ERL_LIBS) PATH=$(LFE_PATH) lfe \
	-eval "rpc:call('pflux@$${HOSTNAME}', init, stop, [])" \
	-name controller@$${HOSTNAME} -setcookie `cat ~/.erlang.cookie` \
	-noshell -s erlang halt
