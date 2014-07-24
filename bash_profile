eval "$(rbenv init -)"
export PATH="/usr/local/share/npm/bin:/usr/local/Cellar/postgresql/9.3.2/bin:./bin:$PATH"
export PATH=${PATH}:/Users/stellard/Development/sdk/platform-tools:/Users/stellard/Development/sdk/tools

export PATH=/Users/stellard/scripts/bash_scripts:$PATH
export PATH=/Users/stellard/scripts/s3sync:$PATH
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

export MONDRIAN_XMLA=/Users/stellard/projects/kuji/mondrian-xmla

export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=`ls -1 $EC2_HOME/pk-*.pem`
export EC2_CERT=`ls -1 $EC2_HOME/cert-*.pem`
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

export HUSKY_HOME=/Users/stellard/projects/kuji/fido
export HUSKY_ENV=development


export EDITOR="mvim" 
export GIT_EDITOR="vim"
export KUJI_PROJECTS_DIR="/Users/stellard/projects/kuji"

source ~/.kuji-bash/kuji-bash.sh

alias edit="mvim"
alias gh="cd ~/projects/github"

alias cukeoff="export AUTOFEATURE=false"
alias cukeon="export AUTOFEATURE=true"

alias atest="bundle exec guard -g tests"
alias serve="bundle exec guard -g server"

alias pryc='pry -r ./config/environment'

alias ls="ls -al"

alias dir="ls"

alias cuke='bundle exec cucumber -r features'

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi
 
if [ -f ~/bash_completion.d/knife ]; then
  . ~/bash_completion.d/knife
fi

# export GIT_PS1_SHOWDIRTYSTATE=true
# export GIT_PS1_SHOWUPSTREAM="auto"
# 
# export PS1='\[\033[01;34m\]\w\[\033[00;35m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
# export TERM="xterm-color"
# export CLICOLOR=1
# export LSCOLORS=ExFxCxDxBxegedabagacad

for f in ~/.app_config/*; do source $f; done
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
