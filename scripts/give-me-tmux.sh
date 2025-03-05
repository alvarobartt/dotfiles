#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 --session-name SESSION_NAME --directory DIRECTORY [--python]"
    exit 1
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --session-name)
            if [ -n "$2" ]; then
                SESSION_NAME="$2"
                shift
            else
                echo "Error: --session-name requires a value."
                usage
            fi
            ;;
        --directory)
            if [ -n "$2" ]; then
                DIRECTORY="$2"
                shift
            else
                echo "Error: --directory requires a value."
                usage
            fi
            ;;
        --python)
            IS_PYTHON_PROJECT=false
            ;;
        *)
            echo "Unknown parameter passed: $1"
            usage
            ;;
    esac
    shift
done

# Check if mandatory parameters are provided
if [ -z "$SESSION_NAME" ] || [ -z "$DIRECTORY" ]; then
    echo "Error: Both --session-name and --directory are required parameters."
    usage
fi

# Function to activate the Python environment if it's a Python project
activate_env() {
    if [ "$IS_PYTHON_PROJECT" = true ]; then
        echo "&& source .venv/bin/activate.fish"
    fi
}

# Start a new tmux session
tmux new-session -d -s "$SESSION_NAME" -n "${SESSION_NAME}-nvim"

# Set up the first window (nvim)
tmux send-keys -t "$SESSION_NAME:${SESSION_NAME}-nvim" "cd $DIRECTORY $(activate_env) && nvim ." C-m

# Set up the second window (shell)
tmux new-window -a -t "$SESSION_NAME" -n "${SESSION_NAME}-shell"
tmux send-keys -t "$SESSION_NAME:${SESSION_NAME}-shell" "cd $DIRECTORY $(activate_env)" C-m

# Select the first window and attach to the session
tmux select-window -t "$SESSION_NAME:${SESSION_NAME}-nvim"
tmux attach-session -t "$SESSION_NAME"
