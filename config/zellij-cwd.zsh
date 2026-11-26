# Report the local directory to Zellij so new tabs can inherit it.
if [[ -n ${ZELLIJ_PANE_ID-} ]]; then
  autoload -Uz add-zsh-hook
  _zellij_report_cwd() {
    emulate -L zsh
    setopt NO_MULTIBYTE
    local LC_ALL=C character escaped encoded_path=''

    for character in "${(s::)PWD}"; do
      case $character in
        [a-zA-Z0-9/._~-]) encoded_path+=$character ;;
        *)
          printf -v escaped '%%%02X' "'$character"
          encoded_path+=$escaped
          ;;
      esac
    done

    printf '\e]7;file://%s%s\e\\' "$HOST" "$encoded_path"
  }
  add-zsh-hook precmd _zellij_report_cwd
fi
