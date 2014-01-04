kursynbp
========
simple currency exchange API (source: NBP xml files)
---
###Usage:

`GET http://[server]/api/[date],[currency_symbol].json`

###Returns JSON:
`{"code":[return code (0 or error code)],"message":[return message ("OK" or error message)],"exchange":[exchange rate (if found) or nil]}`

###Working app:
<http://kursynbp.herokuapp.com/api/140103,THB.json>