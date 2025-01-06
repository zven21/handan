iex: 
	iex --erl "-kernel shell_history enabled" -S mix

server:
	iex --erl "-kernel shell_history enabled" -S mix phx.server

format:
	mix format