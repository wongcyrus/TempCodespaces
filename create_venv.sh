#!/bin/bash

# Script to create a Python virtual environment

# --- Configuration ---
# Customize these variables if needed
VENV_NAME="my_venv"  # Name of the virtual environment directory
PYTHON_VERSION="python3" # or "python3.9", "python3.10" etc. to specify a version.
REQUIREMENTS_FILE="requirements.txt" # Name of the requirements file (if you have one).

# --- Script Logic ---

# Check if the specified Python version is installed
if ! command -v "$PYTHON_VERSION" &> /dev/null
then
    echo "Error: $PYTHON_VERSION is not installed. Please install it first."
    exit 1
fi

# Check if virtualenv is installed. If not, try to install it.
if ! command -v virtualenv &> /dev/null
then
    echo "virtualenv is not installed. Attempting to install..."
    "$PYTHON_VERSION" -m pip install --upgrade pip
    "$PYTHON_VERSION" -m pip install virtualenv
    if [ $? -ne 0 ]; then
      echo "Failed to install virtualenv. Please install it manually (e.g., '$PYTHON_VERSION -m pip install virtualenv') and try again."
      exit 1
    else
      echo "virtualenv installed successfully."
    fi
fi

# Check if the virtual environment already exists
if [ -d "$VENV_NAME" ]; then
    echo "Virtual environment '$VENV_NAME' already exists."
    echo "If you want to recreate it, delete the folder '$VENV_NAME' first"
    exit 1
fi

# Create the virtual environment
echo "Creating virtual environment '$VENV_NAME'..."
virtualenv "$VENV_NAME" -p "$PYTHON_VERSION"
if [ $? -ne 0 ]; then
    echo "Error creating virtual environment."
    exit 1
fi

echo "Virtual environment '$VENV_NAME' created successfully."

# Optional: Install dependencies from requirements.txt
if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "Installing dependencies from '$REQUIREMENTS_FILE'..."
    source "$VENV_NAME/bin/activate"
    pip install --upgrade pip
    pip install -r "$REQUIREMENTS_FILE"
    deactivate
    if [ $? -ne 0 ]; then
        echo "Error installing dependencies."
        exit 1
    else
        echo "Dependencies installed successfully."
    fi
else
    echo "No '$REQUIREMENTS_FILE' found. Skipping dependency installation."
fi

echo "---"
echo "To activate the virtual environment, run:"
echo "source $VENV_NAME/bin/activate"
echo "To deactivate it, run:"
echo "deactivate"
echo "---"

exit 0
