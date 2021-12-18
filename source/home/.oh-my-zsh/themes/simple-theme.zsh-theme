PROMPT='%(!.%{$fg[red]%}.%{$fg[green]%})%~%{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%} '

PROMPT="%F{green}%B%n%f@%F{magenta}%m%f:%b %F{cyan}%~%f >%F{cyan}>>%f "
RPROMPT='%(!.%{$fg[red]%}.%{$fg[green]%})$(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY=" ✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"

