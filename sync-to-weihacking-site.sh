#!/usr/bin/env bash
# sync-to-weihacking-site.sh
# Copies only personal brand files from 1596941391qq.github.io to weihacking-site
# Usage: bash scripts/sync-to-weihacking-site.sh

set -euo pipefail

SRC="$HOME/../AI-OPE~2/1596941391qq.github.io"
DST="$HOME/../AI-OPE~2/weihacking-site"

# Resolve to absolute paths
SRC="$(cd "$(dirname "$0")/../1596941391qq.github.io" && pwd)"
DST="$(cd "$(dirname "$0")/../weihacking-site" && pwd)"

echo "SRC: $SRC"
echo "DST: $DST"

# ===== PERSONAL BRAND WHITELIST =====
# Main pages
MAIN_PAGES=(
  index.html
  about.html
  services.html
  thinking.html
  insights.html
  community.html
  knowledge.html
  tools.html
  404.html
  hacking-news.html
  hackingseo-os1-presales.html
  style.css
  script.js
)

# Free tool pages
TOOL_PAGES=(
  meta-description-generator.html
  og-preview-tool.html
  serp-preview-tool.html
  robots-txt-generator.html
  schema-markup-generator.html
  heading-analyzer.html
  keyword-density-checker.html
  sitemap-generator.html
  hreflang-tag-generator.html
  backlink-pool.html
  backlink-sources-full.html
)

# Case study & guide pages
CONTENT_PAGES=(
  seo-case-studies.html
  case-study-leewow.html
  case-study-hakkoai.html
  geo-aeo-optimization-guide.html
  pseo-agent-how-it-works.html
)

# Assets dirs (synced as-is)
ASSET_DIRS=(
  images
)

# Newsletter HTML only (not PDFs)
NEWSLETTER_HTML=(
  issue-01.html
  issue-02.html
  issue-03.html
  issue-04.html
  issue-05.html
  issue-special-ecommerce-interception.html
)

# ===== SYNC FUNCTIONS =====

sync_files() {
  local files=("$@")
  for f in "${files[@]}"; do
    if [ -f "$SRC/$f" ]; then
      cp "$SRC/$f" "$DST/$f"
      echo "  synced: $f"
    else
      echo "  SKIP (not found): $f"
    fi
  done
}

# ===== EXECUTE =====

echo ""
echo "=== Syncing main pages ==="
sync_files "${MAIN_PAGES[@]}"

echo ""
echo "=== Syncing tool pages ==="
sync_files "${TOOL_PAGES[@]}"

echo ""
echo "=== Syncing content pages ==="
sync_files "${CONTENT_PAGES[@]}"

echo ""
echo "=== Syncing newsletter HTML ==="
mkdir -p "$DST/newsletter"
for f in "${NEWSLETTER_HTML[@]}"; do
  if [ -f "$SRC/newsletter/$f" ]; then
    cp "$SRC/newsletter/$f" "$DST/newsletter/$f"
    echo "  synced: newsletter/$f"
  else
    echo "  SKIP (not found): newsletter/$f"
  fi
done

echo ""
echo "=== Syncing asset directories ==="
for d in "${ASSET_DIRS[@]}"; do
  if [ -d "$SRC/$d" ]; then
    rsync -a --delete "$SRC/$d/" "$DST/$d/" 2>/dev/null || {
      # Fallback for Windows without rsync
      rm -rf "$DST/$d"
      cp -r "$SRC/$d" "$DST/$d"
    }
    echo "  synced: $d/"
  fi
done

# ===== CLEANUP: remove internal files from DST =====

echo ""
echo "=== Cleaning internal files from weihacking-site ==="

# Files to remove (dashboards, strategies, invoices, CRM, etc.)
INTERNAL_PATTERNS=(
  "*-dashboard.html"
  "*-seo-strategy.html"
  "intent-workbench.html"
  "tool-dir-grid.html"
  "302-ai-review.md"
  "ai-*.md"
)

for pattern in "${INTERNAL_PATTERNS[@]}"; do
  for f in $DST/$pattern; do
    if [ -f "$f" ]; then
      rm "$f"
      echo "  removed: $(basename "$f")"
    fi
  done
done

# Remove internal directories
INTERNAL_DIRS=(
  "hakkoai-invoice"
  "leewow-invoice"
  "crm"
  "about-materials"
  "newsletter/*.pdf"
)

for d in "${INTERNAL_DIRS[@]}"; do
  for f in $DST/$d; do
    if [ -e "$f" ]; then
      rm -rf "$f"
      echo "  removed: $(basename "$f")"
    fi
  done
done

# Remove newsletter PDFs
rm -f "$DST/newsletter/"*.pdf 2>/dev/null && echo "  removed: newsletter PDFs" || true

echo ""
echo "=== Generating clean robots.txt ==="
cat > "$DST/robots.txt" << 'EOF'
User-agent: *
Allow: /
Sitemap: https://weihacking.com/sitemap.xml
EOF
echo "  wrote robots.txt"

echo ""
echo "=== Sync complete ==="
echo "Review changes in weihacking-site, then:"
echo "  cd $DST && git add -A && git status"
