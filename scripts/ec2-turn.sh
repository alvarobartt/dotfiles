#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 <on|off> <instance-name> [region] [profile]"
    echo "  on:  Start the EC2 instance by name"
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

retry_action() {
    local action_cmd="$1"
    local wait_cmd="$2"
    local action="$3"
    local instance_id="$4"
    local output=""

    for ATTEMPT in {1..5}; do
        echo "[$ATTEMPT/5] Attempting to $action instance '$INSTANCE_NAME' ($instance_id)..."
        set +e
        output=$(eval "$action_cmd" 2>&1)
        rc=$?
        set -e
        if [[ $rc -eq 0 ]]; then
            echo "'$action' command accepted. Waiting for instance state change..."
            eval "$wait_cmd"
            echo "Instance '$INSTANCE_NAME' ($instance_id) is now ${action/ing/ed}."
            return 0
        else
            echo "Failed to $action instance. AWS CLI output:"
            echo "$output"
            [[ $ATTEMPT -lt 5 ]] && echo "Retrying in 10s..." && sleep 10
        fi
    done

    echo "Error: Failed to $action instance '$INSTANCE_NAME' ($instance_id) after 5 attempts."
    echo "Last AWS CLI error:"
    echo "$output"
    echo "Advice: Please check your AWS quotas/capacity or try again later."
    exit 3
}

INSTANCE_ID=$(get_instance_id)
if [[ -z "$INSTANCE_ID" ]]; then
    echo "Error: No instance found with name '$INSTANCE_NAME'."
    exit 2
fi

case "$SUBCMD" in
on)
    retry_action \
        "aws ec2 start-instances --instance-ids \"$INSTANCE_ID\" ${AWS_OPTS[*]}" \
        "aws ec2 wait instance-running --instance-ids \"$INSTANCE_ID\" ${AWS_OPTS[*]}" \
        "start" \
        "$INSTANCE_ID"
    ;;
off)
    retry_action \
        "aws ec2 stop-instances --instance-ids \"$INSTANCE_ID\" ${AWS_OPTS[*]}" \
        "aws ec2 wait instance-stopped --instance-ids \"$INSTANCE_ID\" ${AWS_OPTS[*]}" \
        "stop" \
        "$INSTANCE_ID"
    ;;
*)
    usage
    ;;
esac
