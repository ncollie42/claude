#!/bin/bash

# Build script for Space Invaders 3D

echo "Building Space Invaders 3D..."

# Compile with Odin
odin build src -out:space_invaders_3d -debug

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "Run with: ./space_invaders_3d"
else
    echo "Build failed!"
    exit 1
fi
