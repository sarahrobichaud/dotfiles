#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: preview-latex <file.tex>"
    exit 1
fi

base="${1%.tex}"
tex_file="${base}.tex"
pdf_file="${base}.pdf"

if [ ! -f "$tex_file" ]; then
    echo "Error: File '$tex_file' not found."
    exit 1
fi

# Compile once up front so a fresh .tex produces its PDF before the watcher
# starts (previously the script errored out before ever compiling).
latexmk -xelatex -interaction=nonstopmode "$tex_file" || {
    echo "Error: PDF compilation failed."
    exit 1
}

echo "Opening $pdf_file in Zathura..."
zathura "$pdf_file" >/dev/null 2>&1 &

echo "Starting continuous watch mode (Press Ctrl+C to stop)..."
latexmk -xelatex -pvc -interaction=nonstopmode "$tex_file"
