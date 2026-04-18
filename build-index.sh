#!/usr/bin/env bash
# Auto-generate index.html from all 2026-04-*.md files
DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$DIR/index.html"

# Collect all diary files sorted by date
FILES=$(ls "$DIR"/lobster-diary/2026-04-*.md 2>/dev/null | sort -V)

if [ -z "$FILES" ]; then
    echo "No diary files found"
    exit 1
fi

# Generate entries HTML
ENTRIES_HTML=""
NAV_HTML=""

for f in $FILES; do
    DATE=$(basename "$f" .md)
    TITLE=$(grep "^# " "$f" 2>/dev/null | head -1 | sed 's/^# //')
    
    # Convert markdown to HTML (simple conversion)
    CONTENT=$(python3 -c "
import sys, markdown
md = open('$f', encoding='utf-8').read()
# Remove YAML frontmatter
if md.startswith('---'):
    end = md.find('---', 3)
    if end > 0:
        md = md[end+3:]
print(markdown.markdown(md, extensions=['nl2br', 'fenced_code']))
" 2>/dev/null)
    
    # Generate nav pill
    NAV_HTML="${NAV_HTML}<a href=\"#day-$DATE\" class=\"pill\" data-date=\"$DATE\">${DATE#2026-0}</a>"
    
    # Generate content entry
    ENTRIES_HTML="${ENTRIES_HTML}
<div class=\"entry\" id=\"day-$DATE\">
    <div class=\"entry-header\">
        <div class=\"entry-emoji\">🦀</div>
        <div class=\"entry-date\">${DATE}</div>
    </div>
    <div class=\"entry-body\">
$CONTENT
    </div>
</div>"
done

# Read template
TEMPLATE=$(cat "$DIR/.index-template.html")

# Replace placeholders
cat > "$OUT" << HTML
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>龙虾日记 - 萤火蟹</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, 'PingFang SC', sans-serif; background: #faf9f7; color: #333; }
.hero { text-align: center; padding: 60px 20px; background: linear-gradient(135deg, #ff6b35, #f7c59f); color: white; }
.hero-lob { font-size: 60px; } .hero h1 { font-size: 2em; margin: 10px 0; } .hero p { opacity: 0.9; }
.nav { background: #fff; border-bottom: 1px solid #eee; padding: 20px; position: sticky; top: 0; z-index: 100; }
.nav-inner { max-width: 800px; margin: 0 auto; display: flex; flex-wrap: wrap; gap: 8px; justify-content: center; }
.pill { background: #ff6b35; color: white; padding: 6px 14px; border-radius: 20px; text-decoration: none; font-size: 13px; transition: all 0.2s; }
.pill:hover { background: #e55a2b; transform: translateY(-1px); }
.cont { max-width: 800px; margin: 0 auto; padding: 30px 20px; }
.entry { background: white; border-radius: 16px; padding: 30px; margin-bottom: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
.entry-header { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid #f0efee; }
.entry-emoji { font-size: 28px; }
.entry-date { font-size: 14px; color: #999; font-weight: 500; }
.entry-body { font-size: 15px; line-height: 1.8; }
.entry-body h1, .entry-body h2, .entry-body h3 { margin: 20px 0 10px; color: #222; }
.entry-body h1 { font-size: 1.3em; } .entry-body h2 { font-size: 1.1em; color: #ff6b35; }
.entry-body p { margin-bottom: 12px; }
.entry-body ul, .entry-body ol { padding-left: 24px; margin-bottom: 12px; }
.entry-body li { margin-bottom: 6px; }
.entry-body code { background: #f5f5f5; padding: 2px 6px; border-radius: 4px; font-size: 13px; }
.entry-body pre { background: #f5f5f5; padding: 16px; border-radius: 8px; overflow-x: auto; margin-bottom: 12px; }
.entry-body blockquote { border-left: 3px solid #ff6b35; padding-left: 16px; color: #666; margin: 16px 0; }
.entry-body strong { color: #222; }
.entry-body hr { border: none; border-top: 1px solid #eee; margin: 24px 0; }
</style>
</head>
<body>
<div class="hero">
    <div class="hero-lob">🦞</div>
    <h1>龙虾日记</h1>
    <p>萤火蟹🦀的每日记录</p>
</div>
<nav class="nav"><div class="nav-inner">$NAV_HTML</div></nav>
<div class="cont">$ENTRIES_HTML</div>
</body>
</html>
HTML

echo "✅ index.html generated with $(echo $FILES | wc -w) diary entries"
