#!/bin/bash

echo "=== LAL LINK TEST REPORT ==="
echo "Scanning all HTML files for broken links..."
echo ""

# Extract all hrefs from HTML files
broken_links=0
total_links=0
external_links=0

for htmlfile in *.html; do
  echo ">>> $htmlfile"
  
  # Extract all href values
  grep -o 'href="[^"]*"' "$htmlfile" | sed 's/href="//;s/"$//' | while read link; do
    total_links=$((total_links + 1))
    
    # Check if it's an external link
    if [[ $link == http* ]] || [[ $link == mailto* ]]; then
      external_links=$((external_links + 1))
      # echo "  ✓ EXTERNAL: $link"
    elif [[ $link == "#"* ]]; then
      # Anchor link - valid
      echo "  ✓ ANCHOR: $link"
    elif [[ $link == *".html" ]]; then
      # Local HTML file - check if exists
      if [ -f "${link}" ]; then
        echo "  ✓ LOCAL: $link"
      else
        echo "  ✗ BROKEN: $link (file not found)"
        broken_links=$((broken_links + 1))
      fi
    else
      echo "  ? OTHER: $link"
    fi
  done
  echo ""
done

echo "=== SUMMARY ==="
echo "Total links found: $total_links"
echo "External links: $external_links"
echo "Broken local links: $broken_links"
