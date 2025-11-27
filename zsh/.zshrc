

HISTSIZE=10000
export PATH=/Applications/Postgres.app/Contents/Versions/14/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(rbenv init -)"

# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl)"




# Use a minimal prompt in Cursor to avoid command detection issues
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  PROMPT='%n@%m:%~%# '
  RPROMPT=''
else
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  source /opt/homebrew/opt/gitstatus/gitstatus.prompt.zsh
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

  # Use the full prompt for other terminals
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi



autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

export PATH=$PATH:/Users/stellard/Library/Python/3.13/bin
# source venv/bin/activate # for zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh







git-cleanup-hotfix-branches() {
  local dry_run=false
  if [[ "$1" == "--dry-run" ]]; then
    dry_run=true
    echo "DRY RUN MODE - No branches will be deleted"
  fi
  git fetch -p
  LATEST_DATE=$(git branch -r --list "origin/hotfix/*" | grep -E "origin/hotfix/(release|hotfix)-([0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{4})" | sed -E "s/origin\/hotfix\/(release|hotfix)-([0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{4})/\2/" | sort -V -r | head -1 | tr -d " ")
  LATEST_BRANCH=$(git branch -r --list "origin/hotfix/*" | grep "$LATEST_DATE" | tr -d " ")
  BRANCHES_TO_DELETE=$(git branch -r --list "origin/hotfix/*" | grep -v "$LATEST_BRANCH")
  echo "Latest branch (keeping): $LATEST_BRANCH"
  echo "Branches to delete:"
  echo "$BRANCHES_TO_DELETE"
  if [[ "$dry_run" == true ]]; then
    echo "DRY RUN: Would delete $(echo "$BRANCHES_TO_DELETE" | wc -l) branches"
  else
    echo "Deleting branches..."
    echo "$BRANCHES_TO_DELETE" | while read branch; do
      if git ls-remote --heads origin "${branch#origin/}" | grep -q .; then
        git push origin --delete "${branch#origin/}"
      else
        echo "Branch ${branch#origin/} does not exist on remote, skipping..."
      fi
    done
  fi
}


git-cleanup-branches() {
  git fetch -p

  # Get current branch
  local current_branch=$(git branch --show-current)

  # Determine main branch (main, master, or develop)
  local main_branch=""
  if git show-ref --verify --quiet refs/heads/main; then
    main_branch="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    main_branch="master"
  elif git show-ref --verify --quiet refs/heads/develop; then
    main_branch="develop"
  else
    echo "Error: Could not find main/master/develop branch"
    return 1
  fi

  # Find branches with gone remote tracking branches
  local gone_branches=$(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}')

  # Find merged branches (only check against main branch, not current branch)
  # Exclude branches with + prefix (worktree branches) and strip *, +, and whitespace
  local merged_branches=$(git branch --merged "$main_branch" | grep -v "^[[:space:]]*+" | grep -v "\*\|main\|master\|develop" | sed -E 's/^[[:space:]]*[*][[:space:]]*//' | sed 's/^[[:space:]]*//' | sed '/^$/d')

  # Filter out current branch from both lists
  gone_branches=$(echo "$gone_branches" | grep -v "^$current_branch$" || true)
  merged_branches=$(echo "$merged_branches" | grep -v "^$current_branch$" || true)

  # Combine and deduplicate all branches to delete
  local all_branches_to_delete=$(printf "%s\n%s" "$gone_branches" "$merged_branches" | sort -u)

  if [[ -z "$all_branches_to_delete" ]]; then
    echo "No branches to clean up!"
    return 0
  fi

  echo "Branches that will be deleted:"
  echo ""

  local has_unsafe_branches=false

  if [[ -n "$gone_branches" ]]; then
    echo "Branches with gone remote tracking branches:"
    echo "$gone_branches" | while read branch; do
      # Check if branch has commits not on any remote
      local unpushed=$(git log "$branch" --not --remotes --oneline 2>/dev/null | wc -l | tr -d ' ')
      if [[ "$unpushed" -gt 0 ]]; then
        echo "  ⚠ $branch (remote gone, but has $unpushed unpushed commit(s))"
        has_unsafe_branches=true
      else
        echo "  - $branch (remote gone, safe to delete)"
      fi
    done
    echo ""
  fi

  if [[ -n "$merged_branches" ]]; then
    echo "Branches merged into $main_branch:"
    echo "$merged_branches" | while read branch; do
      echo "  - $branch (merged, safe to delete)"
    done
    echo ""
  fi

  if [[ "$has_unsafe_branches" == true ]]; then
    echo "⚠️  WARNING: Some branches have unpushed commits!"
    echo ""
  fi

  echo -n "Delete these branches? (y/N): "
  read -r response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    return 0
  fi

  echo ""
  echo "Deleting branches..."

  # Delete each branch only once, using appropriate method
  echo "$all_branches_to_delete" | while read branch; do
    if [[ "$branch" == "$current_branch" ]]; then
      echo "  ⚠ Skipping $branch (this is your current branch)"
      continue
    fi

    # Check if branch is in gone_branches (use -D for force delete) or merged_branches (try -d first, then -D)
    if echo "$gone_branches" | grep -q "^$branch$"; then
      # Gone branch - use force delete
      local delete_output=$(git branch -D "$branch" 2>&1)
      if echo "$delete_output" | grep -q "Deleted branch"; then
        echo "  ✓ Deleted $branch (remote gone)"
      else
        echo "  ✗ Failed to delete $branch"
        echo "    Error: $delete_output"
      fi
    else
      # Merged branch - try safe delete first, then force delete if needed
      local delete_output=$(git branch -d "$branch" 2>&1)
      if echo "$delete_output" | grep -q "Deleted branch"; then
        echo "  ✓ Deleted $branch (merged)"
      else
        # Safe delete failed, but we know it's merged, so try force delete
        local force_output=$(git branch -D "$branch" 2>&1)
        if echo "$force_output" | grep -q "Deleted branch"; then
          echo "  ✓ Deleted $branch (merged, force deleted)"
        else
          echo "  ✗ Failed to delete $branch"
          echo "    Error: $force_output"
        fi
      fi
    fi
  done
}