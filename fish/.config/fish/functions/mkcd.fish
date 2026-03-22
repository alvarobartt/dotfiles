function mkcd --description 'Create a directory and enter it'
    mkdir -p $argv
    and cd $argv[-1]
end
