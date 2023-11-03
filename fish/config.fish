if status is-interactive
  # Commands to run in interactive sessions can go here
  eval (/opt/homebrew/bin/brew shellenv)

  set -x PYENV_ROOT $HOME/.pyenv
  set -x N_PREFIX $HOME/.n
  set -x RUSTUP_HOME $HOME/.rustup
  set -x CARGO_HOME $HOME/.cargo
  set -x PATH $PATH $HOME/.n/bin
  set -x PATH $PYENV_ROOT/bin $PATH
  set -x PATH $PATH $CARGO_HOME/bin

  alias vim=nvim
  alias vi=nvim
  alias kube=kubectl
  alias tilt=/opt/homebrew/bin/tilt
  alias tlt=/opt/homebrew/bin/tilt

  eval pyenv init --path | source
  eval rbenv init - | source
  #eval /opt/homebrew/share/google-cloud-sdk/path.fish.inc | source

  set -x PATH $HOME/.poetry/bin $PATH
  set fish_greeting

  starship init fish | source
end
