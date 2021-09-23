script = bls

config_file   = ${script}.conf
info_file     = ${script}.info
mirror_script = mirror-efi

bin_dir = /usr/local/bin
etc_dir = /etc

shell      != which zsh || echo /bin/bash
has_zsh    != which zsh
has_bash   != which bash
has_pv     != which pv
has_pigz   != which pigz
has_cifs   != which smbinfo
has_nmap   != which nmap
has_mdadm  != which mdadm
has_smb    != which nmblookup
has_smbcl  != which smbclient
has_nmap   != which nmap
has_perl   != which perl
has_blkid  != which blkid
has_ipcalc != which ipcalc
has_host   != which host
has_ext4   != which mkfs.ext4
has_dos    != which mkfs.vfat
has_less   != which less

packages =  $(if ${has_zsh},,zsh)
packages += $(if ${has_pv},,pv)
packages += $(if ${has_pigz},,pigz)
packages += $(if ${has_cifs},,cifs-utils)
packages += $(if ${has_nmap},,nmap)
packages += $(if ${has_mdadm},,mdadm)
packages += $(if ${has_smb},,samba-common)
packages += $(if ${has_smbcl},,smbclient)
packages += $(if ${has_nmap},,nmap)
packages += $(if ${has_perl},,perl-base)
packages += $(if ${has_blkid},,util-linux)
packages += $(if ${has_ipcalc},,ipcalc)
packages += $(if ${has_host},,bind9-host)
packages += $(if ${has_ext4},,e2fsprogs)
packages += $(if ${has_dos},,dosfstools)
packages += $(if ${has_less},,less)

bash_complete = complete.bash
zsh_complete  = complete.zsh

bash_complete_dir = /etc/bash_completion.d
zsh_complete_dir != \
	which zsh >/dev/null && \
	zsh -c "typeset -p 1 fpath" | \
	sed -e 's/^ *//' | \
	awk '/Completion.*\/Unix/{print}'

help:
	@echo
	@echo "   syntax: make {install|uninstall}"
	@echo

install:   .run_as_root .empty_echo .install_packages .install_files
	@echo

uninstall: .run_as_root .empty_echo .uninstall_files
	@echo

.install_packages: .run_as_root
	@if [ ":${packages}:" != ":               :" ]; then \
		echo "   Installing missing packages"; \
		echo "   ------------------------------------------------------------"; \
		apt-get --assume-yes -qq install ${packages} |\
	       	grep --line-buffered -v 'Reading database' |\
		sed -e 's/^/   /'; \
		echo "   ------------------------------------------------------------"; \
		echo "";\
	fi
 

.run_as_root:
	@if ! [ "$(shell id -u)" = 0 ]; then \
		echo "\e[31m"; \
		echo "You are not root, run this target as root please!"; \
		echo "\e[0m"; \
		exit 1; \
	fi

.empty_echo:
	@echo

.install_files:
	@echo -n "   Installing files ...................... "
	@[ -z ${root_dir} ] || \
		[ -d ${root_dir}/${bin_dir} ] || \
		mkdir -p ${root_dir}/${bin_dir}
	@[ -z ${root_dir} ] || \
		[ -d ${root_dir}/${bash_complete_dir} ] || \
		mkdir -p ${root_dir}/${bash_complete_dir}
	@cat src/${script}|\
		sed -e "/__BLS_CONFIG_FILE__/e   (base64 src/${config_file}   | sed -e 's/^/		/')"  \
		    -e "/__BLS_INFO_FILE__/e     (base64 src/${info_file}     | sed -e 's/^/		/')"  \
		    -e "/__BLS_MIRROR_SCRIPT__/e (base64 src/${mirror_script} | sed -e 's/^/		/')"  |\
		grep -v \
		  -e "__BLS_INFO_FILE" \
		  -e "__BLS_MIRROR_SCRIPT__" \
		  -e "__BLS_CONFIG_FILE__" > ${root_dir}${bin_dir}/${script}
	@chmod 755 ${root_dir}${bin_dir}/${script}
	@[ -z ${has_bash} ] || cp src/${bash_complete} ${root_dir}/${bash_complete_dir}/${script}
	@[ -z ${has_zsh}  ] || cp src/${zsh_complete}  ${root_dir}/${zsh_complete_dir}/_${script}
	@echo ${root_dir}/${zsh_complete_dir}/_${script}
	@echo DONE

.uninstall_files:
	@echo -n "   Uninstalling files .................... "
	@[ ! -f ${bin_dir}/${script}      ] || rm -f ${bin_dir}/${script}
	@[ ! -f ${bash_complete_dir}/${script} ] || rm -f ${bash_complete_dir}/${script}
	@[ ! -f ${zsh_complete_dir}/_${script} ] || rm -f ${zsh_complete_dir}/_${script}
	@echo DONE
