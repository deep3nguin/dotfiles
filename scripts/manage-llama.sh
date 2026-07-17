#!/usr/bin/env bash
#
# manage-llama.sh - Start/stop llama.cpp server on-demand to manage VRAM usage (lazy loading)
#

set -euo pipefail

MODEL_PATH="${1:-$HOME/.local/share/models/llama-3.2-3b-instruct.gguf}"
PORT=8080
PID_FILE="/tmp/llama-server.pid"

start_server() {
    if [ ! -f "$MODEL_PATH" ]; then
        echo "Error: Model file not found at $MODEL_PATH" >&2
        echo "Please place your GGUF model in ~/.local/share/models/ or provide the path." >&2
        exit 1
    fi

    if curl -s "http://localhost:$PORT/health" &>/dev/null; then
        echo "Llama server is already running."
        exit 0
    fi

    echo "Starting llama.cpp server in background..."
    # Start llama-server and offload layers to GPU for acceleration
    llama-server \
        --model "$MODEL_PATH" \
        --port "$PORT" \
        --ctx-size 4096 \
        --n-gpu-layers 99 \
        --threads 4 \
        > /tmp/llama-server.log 2>&1 &
    
    local pid=$!
    echo $pid > "$PID_FILE"
    
    echo -n "Waiting for model to load into VRAM..."
    for i in {1..30}; do
        if curl -s "http://localhost:$PORT/health" &>/dev/null; then
            echo " Server ready on port $PORT!"
            exit 0
        fi
        sleep 1
        echo -n "."
    done
    echo " Timeout waiting for llama-server to start."
    exit 1
}

stop_server() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        echo "Stopping llama.cpp server (PID $pid) to free up VRAM..."
        kill "$pid" 2>/dev/null || true
        rm -f "$PID_FILE"
        echo "Server stopped."
    else
        pkill llama-server || true
        echo "Llama server processes stopped."
    fi
}

status_server() {
    if curl -s "http://localhost:$PORT/health" &>/dev/null; then
        echo "Llama server status: RUNNING (consuming VRAM)"
    else
        echo "Llama server status: STOPPED (VRAM free)"
    fi
}

case "${2:-start}" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    status)
        status_server
        ;;
    *)
        echo "Usage: $0 [model_path] [start|stop|status]"
        exit 1
        ;;
esac
