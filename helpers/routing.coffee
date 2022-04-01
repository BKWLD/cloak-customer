# Get the current apex (root) domain
export currentApexDomain = ->
	location.hostname.match(/(?:^|\.)((?:[^.]+\.)?[^.]+)$/)[1]
