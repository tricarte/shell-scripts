#!/usr/bin/env bash
set -e
export FZF_DEFAULT_COMMAND='fd -E .git'
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g "" --md --php'

main() {
  previous_file="$1"
  file_to_edit=$(select_file "$previous_file")

  if [ -n "$file_to_edit" ] ; then
    $(which vim) --remote-silent "$file_to_edit"
    main "$file_to_edit"
  fi
}

select_file() {
  given_file="$1"
  # find . -type f -exec grep -Iq . {} \; -and -print | fzf --preview="cat {}" --preview-window=right:70%:wrap --query="$given_file"
  fzf --preview="bat --color always {}" --preview-window=right:70%:wrap --query="$given_file"
}

main ""