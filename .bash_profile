#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ `which keychain 2> /dev/null` ]] && [[ -f ${HOME}/.ssh/id_rsa ]] ; then

    eval $(keychain --eval --agents ssh -Q id_rsa)

fi
