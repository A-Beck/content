# platform = multi_platform_all
# reboot = true
# strategy = restrict
# complexity = low
# disruption = low

if [ "$(getconf LONG_BIT)" = "32" ] ; then
  #
  # Set runtime for kernel.exec-shield
  #
  sysctl -q -n -w kernel.exec-shield=1

  #
  # If kernel.exec-shield present in /etc/sysctl.conf, change value to "1"
  #	else, add "kernel.exec-shield = 1" to /etc/sysctl.conf
  #
  {{{ bash_replace_or_append('/etc/sysctl.conf', '^kernel.exec-shield', '1') }}}
fi

if [ "$(getconf LONG_BIT)" = "64" ] ; then
  if grep --silent noexec {{{ grub2_boot_path }}}/grub*.cfg ; then
        sed -i "s/noexec.*//g" /etc/default/grub
        sed -i "s/noexec.*//g" /etc/grub.d/*
        grub2-mkconfig -o "{{{ grub2_boot_path }}}"/grub*.cfg
  fi
fi
