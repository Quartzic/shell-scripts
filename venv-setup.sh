#!/bin/bash

VENV_DIR="venv"
GITIGNORE_FILE=".gitignore"

# Function to update gitignore
update_gitignore() {
    if [ -f "$GITIGNORE_FILE" ]; then
        # Read existing content
        content=$(<"$GITIGNORE_FILE")
        
        # Ensure there's a newline at the end if file is not empty
        if [ -n "$content" ] && [[ ! "$content" =~ \n$ ]]; then
            echo "" >> "$GITIGNORE_FILE"
        fi
        
        # Check if venv/ is already in .gitignore (accounting for empty lines)
        if ! grep -q "^venv/$" "$GITIGNORE_FILE"; then
            echo "venv/" >> "$GITIGNORE_FILE"
            echo "Updated .gitignore"
        fi
    else
        echo "venv/" > "$GITIGNORE_FILE"
        echo "Created .gitignore"
    fi
}

# Function to create virtual environment
create_venv() {
    echo "Creating virtual environment"
    python3 -m venv "$VENV_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create virtual environment"
        return 1
    fi
}

# Main script
update_gitignore

if [ ! -d "$VENV_DIR" ]; then
    create_venv
elif [ ! -f "$VENV_DIR/bin/activate" ]; then
    echo "Recreating corrupted virtual environment"
    rm -rf "$VENV_DIR"
    create_venv
fi

if [ -f "$VENV_DIR/bin/activate" ]; then
    source "$VENV_DIR/bin/activate"
    echo "Virtual environment ready"
fi