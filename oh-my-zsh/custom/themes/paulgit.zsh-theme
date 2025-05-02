# paulgit theme for oh-my-zsh
# Based on Oxide ZSH theme https://github.com/dikiaap/dotfiles
# and customised to my tastes

# Prompt:
# %F => Color codes
# %f => Reset color
# %~ => Current path
# %(x.true.false) => Specifies a ternary expression
#   ! => True if the shell is running with root privileges
#   ? => True if the exit status of the last command was success
#
# Git:
# %a => Current action (rebase/merge)
# %b => Current branch
# %c => Staged changes
# %u => Unstaged changes
#
# Terminal:
# \n => Newline/Line Feed (LF)

setopt PROMPT_SUBST

autoload -U add-zsh-hook
autoload -Uz vcs_info

# Use True color (24-bit) if available.
if [[ "${terminfo[colors]}" -ge 256 ]]; then
    local turquoise="%F{73}"
    local orange="%F{179}"
    local red="%F{167}"
    local limegreen="%F{107}"
else
    local turquoise="%F{cyan}"
    local orange="%F{yellow}"
    local red="%F{red}"
    local limegreen="%F{green}"
fi

local highlight_bg="%K{124}"
local white="%F{15}"

# VCS style formats.
FMT_UNSTAGED="%{$reset_color%} %{$orange%}●"
FMT_STAGED="%{$reset_color%} %{$limegreen%}✚"
FMT_ACTION="(%{$limegreen%}%a%{$reset_color%})"
FMT_VCS_STATUS="on %{$turquoise%} %b%u%c%{$reset_color%}"

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_VCS_STATUS} ${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_VCS_STATUS}"
zstyle ':vcs_info:*' nvcsformats    ""
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

# User name.
function get_usr_name {
    local name="%n"
    if [[ "$USER" == 'root' ]]; then
        name="%{$highlight_bg%}%{$white%}$name%{$reset_color%}"
    fi
    echo $name
}

# Check for untracked files.
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep --max-count=1 '^??' &> /dev/null; then
        hook_com[staged]+="%{$reset_color%} %{$red%}●"
    fi
}

# Executed before each prompt.
add-zsh-hook precmd vcs_info

# Oxide prompt style.
PROMPT=$'\n%{$red%}$(get_usr_name) %{%F{white}%}at %{$orange%}%m: %{$limegreen%}%~%{$reset_color%} ${vcs_info_msg_0_}\n%(?.%{%F{white}%}.%{$red%})%(!.#.❯)%{$reset_color%} '