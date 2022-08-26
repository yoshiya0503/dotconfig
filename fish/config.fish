if status is-interactive
    # Commands to run in interactive sessions can go here
    eval (/opt/homebrew/bin/brew shellenv)

    set -x GOPATH $HOME/.go
    set -x PYENV_ROOT $HOME/.pyenv
    set -x N_PREFIX $HOME/.n
    set -x PATH $PATH $HOME/.n/bin
    set -x PATH $PYENV_ROOT/bin $PATH
    set -x PATH $PATH $GOPATH/bin

    alias vim=nvim
    alias kube=kubectl
    alias tilt=/opt/homebrew/bin/tilt
    alias tlt=/opt/homebrew/bin/tilt

    eval pyenv init --path | source
    eval rbenv init - | source

    set -x PATH $HOME/.poetry/bin $PATH
    set -x HRB_TILT 1
    set fish_greeting

    starship init fish | source
end
