[[ -s "/Users/stellard/.rvm/scripts/rvm" ]] && source "/Users/stellard/.rvm/scripts/rvm"
for f in ~/.completion_scripts/*; do source $f; done

export PATH=/Users/stellard/scripts/bash_scripts:$PATH
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

export MONDRIAN_XMLA=/Users/stellard/projects/kuji/mondrian-xmla

export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=`ls -1 $EC2_HOME/pk-*.pem`
export EC2_CERT=`ls -1 $EC2_HOME/cert-*.pem`
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/


alias kj="cd ~/projects/kuji"

alias gh="cd ~/projects/github"
alias zen="cd /Users/stellard/projects/tailwind/zenslap"
alias zenc="cd /Users/stellard/projects/tailwind/zenslap-client"
alias log="tail -f ./log/development.log"

alias br="cd /Users/stellard/projects/hubsphere/beaver"
alias fork="cd /Users/stellard/projects/forks"
alias pb="cd /Users/stellard/projects/hubsphere/polarbear"
alias ice="cd /Users/stellard/projects/hubsphere/iceberg"
alias go="cd /Users/stellard/projects/hubsphere/goose"
alias zc="cd /Users/stellard/projects/tailwind/zenslap-client"

alias cukeoff="export AUTOFEATURE=false"
alias cukeon="export AUTOFEATURE=true"

alias atest="bundle exec guard -g tests"
alias serve="bundle exec guard -g server"

alias pryc='pry -r ./config/environment'

alias bashedit="mate ~/.bash_profile"
alias bashup="source ~/.bash_profile"

alias dcz="export DOTCLOUD_CONFIG_FILE=dotcloud.conf"
alias dch="export DOTCLOUD_CONFIG_FILE=hubsphere.conf"
eval dch

alias ssh-ec2='ssh -i ~/.ec2/amazon.pem ec2-user@ec2-50-17-58-185.compute-1.amazonaws.com'

alias ls="ls -al"

alias dir="ls"

alias cuke='bundle exec cucumber -r features'

function ssh-box {
    ssh "rails@carbonhub-00"$1".vm.brightbox.net"
}

function gedit {
	SHOWGEMPATH=`bundle show $1`
	eval "mate "$SHOWGEMPATH
}

function ssh-moon {
	ssh scott@moonshine.hubsphere.com
}

function edit {
	current_rmv=`rvm-prompt`
	eval "rvm use system"
	eval "mvim "$1
	eval "rvm "$current_rmv
}

function authme {
	ssh $1 'cat >>.ssh/authorized_keys' <~/.ssh/id_rsa.pub
}

function mongofix {
	sudo rm -f /usr/local/mongodb_data/mongod.lock
	sudo /usr/local/mongodb/bin/mongod -f /usr/local/mongodb/mongod.conf --repair
}

function ignore {
	echo -e "$1" >> ./.gitignore
}



export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUPSTREAM="auto"

export PS1='\[\033[01;34m\]\w\[\033[00;35m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
export TERM="xterm-color"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

for f in ~/.app_config/*; do source $f; done
