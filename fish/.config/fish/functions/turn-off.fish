function turn-off --description "Turn off an AWS EC2 instance by its instance name"
    if test (count $argv) -lt 1; or test (count $argv) -gt 2
        echo "Usage: turn-off <instance-name> [region]" >&2
        return 1
    end

    set -l region us-east-1
    if test (count $argv) -eq 2
        set region $argv[2]
    end

    "$HOME/ec2-on-off.sh" off $argv[1] $region
end
