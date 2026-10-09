#!/usr/bin/env python3
"""Render pilot2-flyer.html to a single-page letter PDF via headless Chrome."""
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent
HTML = ROOT / "pilot2-flyer.html"
PDF = ROOT / "Vantrue-Pilot-2-Flyer.pdf"

cmd = [
    "google-chrome",
    "--headless=new",
    "--disable-gpu",
    "--no-sandbox",
    "--user-data-dir=/tmp/chrome-pdf-profile",
    "--virtual-time-budget=5000",
    "--run-all-compositor-stages-before-draw",
    f"--print-to-pdf={PDF}",
    "--no-pdf-header-footer",
    f"file://{HTML}",
]
proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
try:
    stdout, _ = proc.communicate(timeout=20)
except subprocess.TimeoutExpired:
    proc.kill()
    stdout, _ = proc.communicate()
    if not PDF.is_file():
        raise RuntimeError(f"Chrome timed out and PDF missing:\n{stdout}")

if not PDF.is_file():
    raise RuntimeError(f"PDF not created:\n{stdout}")

print(f"Wrote {PDF} ({PDF.stat().st_size} bytes)")
