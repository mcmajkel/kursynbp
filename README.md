kursynbp - simple currency exchange API
========
Usage:
-----
get http://[server]/api/[date],[currency_symbol].json

Returns JSON:
-----
{"code":[return code (0 or error code)],"message":[return message ("OK" or error message)],"exchange":[exchange rate (if found) or nil]}
