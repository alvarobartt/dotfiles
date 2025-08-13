#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 <on|off> <instance-name> [region] [profile]"
    echo "   on: Start the EC2 instance by name and print its host IP"
    echo "  off: Stop the EC2 instance by name"
    exit 1
}

if [[ $# -lt 2 ]]; then
    usage
fi

SUBCMD=$1
INSTANCE_NAME=$2
REGION="${3:-}"
PROFILE="${4:-}"

AWS_OPTS=()
[[ -n "$REGION" ]] && AWS_OPTS+=(--region "$REGION")
[[ -n "$PROFILE" ]] && AWS_OPTS+=(--profile "$PROFILE")

get_instance_id() {
    aws ec2 describe-instances \
        "${AWS_OPTS[@]}" \
        --filters "Name=tag:Name,Values=${INSTANCE_NAME}" "Name=instance-state-name,Values=stopped,pending,stopping,running" \
        --query "Reservations[*].Instances[*].InstanceId" \
        --output text
}

get_instance_ip() {
    local field
    field="${1}" # PublicIpAddress or PrivateIpAddress
    aws ec2 describe-instances \
        --instance-ids "$INSTANCE_ID" \
        "${AWS_OPTS[@]}" \
        --query "Reservations[0].Instances[0].${field}" \
        --output text
}

retry_action() {
    local action_cmd="$1"
    local wait_cmd="$2"
    local action="$3"
    local instance_id="$4"
    local output=""
    for ATTEMPT in {1..5}; do
        set +e
        output=$(eval "$action_cmd" 2>&1)
        rc=$?
        set -e
        if [[ $rc -eq 0 ]]; then
            eval "$wait_cmd"
            return 0
        else
            >&2 echo "Failed to $action instance. AWS CLI output:"
            >&2 echo "$output"
            [[ $ATTEMPT -lt 5 ]] && sleep 10
        fi
    done
    >&2 echo "Error: Failed to $action instance '$INSTANCE_NAME' ($instance_id) after 5 attempts."
    >&2 echo "Last AWS CLI error:"
    >&2 echo "$output"
    >&2 echo "Advice: Please check your AWS quotas/capacity or try again later."
    exit 3
}

INSTANCE_ID=$(get_instance_id)
if [[ -z "$INSTANCE_ID" ]]; then
    >&2 echo "Error: No instance found with name '$INSTANCE_NAME'."
    exit 2
fi

case "$SUBCMD" in
on)
    retry_action \
        "aws ec2 start-instances --instance-ids \"$INSTANCE_ID\" ${AWS_OPTS[*]}" \
        "aws ec2 wait instance-running --instance-ids \"$INSTANCE_ID\" ${AWS_OPTS[*]}" \
        "start" \
        "$INSTANCE_ID"
    # Now fetch the public IP (or private if not available)
    IP=$(get_instance_ip PublicIpAddress)
    if [[ "$IP" == "None" || -z "$IP" ]]; then
        # Fallback to private IP if there's no public IP
        IP=$(get_instance_ip PrivateIpAddress)
        if [[ "$IP" == "None" || -z "$IP" ]]; then
            >&2 echo "Error: Instance started but has no public or private IP."
            exit 4
        fi
    fi
    echo "ssh -i ~/HuggingFace/alvaro-dev-us.pem ubuntu@$IP"
    ;;
off)
    # Send stop request without waiting
    set +e
    output=$(aws ec2 stop-instances --instance-ids "$INSTANCE_ID" "${AWS_OPTS[@]}" 2>&1)
    rc=$?
    set -e
    if [[ $rc -eq 0 ]]; then
        echo "Instance $INSTANCE_NAME is stopping already, stopping the instance might take ~2-3 minutes"
    else
        >&2 echo "Failed to stop instance. AWS CLI output:"
        >&2 echo "$output"
        exit 3
    fi
    ;;
*)
    usage
    ;;
esac
