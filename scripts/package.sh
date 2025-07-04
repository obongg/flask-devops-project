#!/bin/bash
set -e

echo "📦 Packaging Flask app..."

# Clean up any previous builds
rm -rf build
mkdir -p build

# Create the archive, wrapping files into a subdirectory called flask-app/
tar -czf build/flask-app.tar.gz \
  --exclude='__pycache__' \
  --exclude='*.pyc' \
  --transform='s,^,flask-app/,' \
  app.py requirements.txt templates/

echo "✅ Package created at build/flask-app.tar.gz"
