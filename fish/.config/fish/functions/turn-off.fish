function turn-off --description "Turn off an AWS EC2 instance by its instance name"
    if test (count $argv) -ne 1
        echo "Usage: turn-off <instance-name>" >&2
        return 1
    end

    "$HOME/ec2-on-off.sh" off $argv[1] us-east-1
end
