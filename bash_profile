eval "$(rbenv init -)"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/share/npm/bin:./bin:$PATH"
export PATH=${PATH}:/Users/stellard/Development/sdk/platform-tools:/Users/stellard/Development/sdk/tools

export PATH=/Users/stellard/scripts/bash_scripts:$PATH
export PATH=/Users/stellard/scripts/s3sync:$PATH
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

export MONDRIAN_XMLA=/Users/stellard/projects/kuji/mondrian-xmla

export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export PATH=$PATH:/Applications/LibreOffice.app/Contents/MacOS
#export EC2_PRIVATE_KEY=`ls -1 $EC2_HOME/pk-*.pem`
#export EC2_CERT=`ls -1 $EC2_HOME/cert-*.pem`
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

alias killruby="ps -ef | grep -E 'spring|ruby|puma|rake' | awk '{print $2}' | xargs kill -9"

alias dir="ls"

alias cuke='bundle exec cucumber -r features'

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi
 
if [ -f ~/bash_completion.d/knife ]; then
  . ~/bash_completion.d/knife
fi

 #export GIT_PS1_SHOWDIRTYSTATE=true
 #export GIT_PS1_SHOWUPSTREAM="auto"
# 
 export PS1='\[\033[01;34m\]\w\[\033[00;35m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
 export TERM="xterm-color"
 export CLICOLOR=1
 export LSCOLORS=ExFxCxDxBxegedabagacad

#for f in ~/.app_config/*; do source $f; done
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

export NVM_DIR="/Users/stellard/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


export HISTSIZE=1000000
export HISTFILESIZE=1000000000

export PATH="$HOME/.cargo/bin:$PATH"



#invoke nvm use when switching dir
find-up () {
    path=$(pwd)
    while [[ "$path" != "" && ! -e "$path/$1" ]]; do
        path=${path%/*}
    done
    echo "$path"
}

cdnvm(){
    cd "$@";
    nvm_path=$(find-up .nvmrc | tr -d '\n')

    # If there are no .nvmrc file, use the default nvm version
    if [[ ! $nvm_path = *[^[:space:]]* ]]; then

        declare default_version;
        default_version=$(nvm version default);

        # If there is no default version, set it to `node`
        # This will use the latest version on your machine
        if [[ $default_version == "N/A" ]]; then
            nvm alias default node;
            default_version=$(nvm version default);
        fi

        # If the current version is not the default version, set it to use the default version
        if [[ $(nvm current) != "$default_version" ]]; then
            nvm use default;
        fi

        elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
        declare nvm_version
        nvm_version=$(<"$nvm_path"/.nvmrc)

        declare locally_resolved_nvm_version
        # `nvm ls` will check all locally-available versions
        # If there are multiple matching versions, take the latest one
        # Remove the `->` and `*` characters and spaces
        # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
        locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

        # If it is not already installed, install it
        # `nvm install` will implicitly use the newly-installed version
        if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
            nvm install "$nvm_version";
        elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
            nvm use "$nvm_version";
        fi
    fi
}
alias cd='cdnvm'

export HISTSIZE=-1
export HISTFILESIZE=-1



export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/stellard/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/stellard/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/stellard/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/stellard/Downloads/google-cloud-sdk/completion.bash.inc'; fi
