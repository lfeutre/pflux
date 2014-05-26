include common.mk

dev:
	@echo "Running OTP app in the foreground ..."
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -eval "application:start('pflux')" \
	-noshell

run: dev

prod:
	@echo "Running OTP app in the background ..."
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -eval "application:start('pflux')" \
	-name pflux@$${HOSTNAME} -setcookie `cat ~/.erlang.cookie` \
	-noshell -detached

daemon: prod

stop:
	@ERL_LIBS=$(ERL_LIBS) $(LFE) \
	-eval "rpc:call('pflux@$${HOSTNAME}', init, stop, [])" \
	-name controller@$${HOSTNAME} -setcookie `cat ~/.erlang.cookie` \
	-noshell -s erlang halt
