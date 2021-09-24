__bls_complete(){
	[[ $COMP_CWORD -gt 2 ]] && return

	if [[ $COMP_CWORD -eq 1 ]]; then
		COMPREPLY=($(compgen -W "backup chroot restore list tag mount info" $2))
		return
	fi


	[[ $3 != backup ]] && return
	[[ ! -f /etc/bls.conf ]] && return

	COMPREPLY=($(
		compgen -W "$(
			awk '/^[ 	]*\[[ 	]*[^ 	]+[ 	]*\][ 	]*(#.*)?$/{print $2}' /etc/bls.conf
		)" $2
	))
}

complete -F __bls_complete bls
