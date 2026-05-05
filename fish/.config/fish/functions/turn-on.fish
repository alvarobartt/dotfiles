function turn-on --description "Turn on an AWS EC2 instance by its instance name"
    if test (count $argv) -ne 1
        echo "Usage: turn-on <instance-name>" >&2
        return 1
    end

    "$HOME/ec2-on-off.sh" on $argv[1] us-east-1
end
