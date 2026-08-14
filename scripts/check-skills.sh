#!/usr/bin/env bash
# Guards the token budget of the skill library.
#
# The library is built on three rules that decay one well-meaning edit at a time
# without a check:
#   1. core.md is the single source of truth — no skill file restates its tables.
#   2. Every relative link resolves.
#   3. No file grows past the point where it should route to detail files.
#
# Scope note: agents/ and rules/ are deliberately exempt from rule 1. They are
# the always-on layer — a system prompt is loaded once and cached, whereas
# reading core.md costs a tool call. Short inline guardrails there are intended.
#
# Usage: scripts/check-skills.sh   (exit 1 on duplication or broken links)

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

SKILLS="unoff-create-plugin"
CORE="$SKILLS/core.md"
SOFT_LIMIT=20000 # bytes; above this, consider routing to detail files
fail=0

# Flat lookup tables that are scanned rather than read top-to-bottom. Splitting
# these would force several reads instead of one — the opposite of the goal.
is_exempt_from_size() {
  case "$1" in
  "$SKILLS/ui/component-mapping.md") return 0 ;;
  *) return 1 ;;
  esac
}

[ -f "$CORE" ] || {
  echo "FAIL: $CORE is missing — it is the single source of truth."
  exit 1
}

# --- 1. no skill file restates core.md -------------------------------------
# Matched on a pipe-delimited table ROW carrying both platform calls, not on
# mere co-occurrence: a file may legitimately document both platforms (e.g.
# app-bootstrap.md documents both boot sequences) without restating the table.
echo "== Duplication of core.md =="
while IFS= read -r f; do
  [ "$f" = "$CORE" ] && continue
  if grep -qE '\|.*figma\.showUI.*\|.*penpot\.ui\.open' "$f"; then
    echo "  RESTATES platform table: $f"
    fail=1
  fi
  if grep -qiE 'four coordinated edits' "$f"; then
    echo "  RESTATES 4-point contract: $f"
    fail=1
  fi
done < <(find "$SKILLS" -name '*.md')

# --- 2. relative links resolve ---------------------------------------------
echo "== Relative links =="
while IFS= read -r line; do
  echo "  BROKEN: $line"
  fail=1
done < <(
  find "$SKILLS" -name '*.md' | while IFS= read -r f; do
    d=$(dirname "$f")
    grep -oE '\]\(\.[^)]*\.md\)' "$f" 2>/dev/null | sed 's/](//;s/)$//' |
      while IFS= read -r l; do
        [ -f "$d/$l" ] || echo "$f -> $l"
      done
  done
)

# --- 3. size budget (advisory) ---------------------------------------------
echo "== Size budget (soft limit ${SOFT_LIMIT}B, advisory) =="
while IFS= read -r f; do
  is_exempt_from_size "$f" && continue
  size=$(wc -c <"$f" | tr -d ' ')
  [ "$size" -gt "$SOFT_LIMIT" ] &&
    echo "  WARN oversize: $f (${size}B) — consider an entry file that routes on"
done < <(find "$SKILLS" -name '*.md')

echo
if [ "$fail" -eq 0 ]; then
  echo "OK: no duplication of core.md, all links resolve."
else
  echo "FAILED. See $CORE and agents/README.md."
fi
exit "$fail"
