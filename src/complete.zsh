#compdef bls

local -a reply
local -a args=(/$'[^\0]#\0'/)


local -a bls_commands

_regex_words bls-commands "bls commands" \
	'tag:tag samba share as backup storage' \
	'info:show exetended info on command usage' \
	'chroot:chroot to restored system' \
	'backup:backup current system' \
	'restore:restore system from backup' \
	'list:list backups from selected server' \
	'mount:mount server share localy'

	args+=($reply[@])


_regex_arguments _bls "${args[@]}"

_bls "$@"
