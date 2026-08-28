---
name: start-session
description: Orient at the start of a work session on the pianobeierna.de Jekyll site — check git status, recent history, and branches, then produce a short briefing of what's changed and what's next. Use when starting a session or asking "where were we / what's next".
disable-model-invocation: true
---

# Start Session

Produce a concise briefing so work can resume with full context. Read, don't change files.

1. **Check working state**: run `git status --short` and `git log --oneline -10`.
2. **Check branches**: run `git branch -a`. Note any branch other than the current one — especially
   one that looks like a pending feature/review branch (e.g. `perf-seo`). Do not merge, rebase onto,
   or otherwise touch such a branch unless explicitly asked to.
3. **Check remote tracking**: `git status -sb` (or `git remote -v` if unclear which remote is
   configured) to confirm whether the current branch tracks a remote before assuming a push will work.
4. **Brief the user**:
   - What changed since the last few commits.
   - Any open/unmerged branches and their apparent purpose.
   - A suggested next step if one is obvious from recent history.
   - Ask which to pursue before making changes.

Keep it tight — orientation, not a report. This is a static Jekyll site (GitHub Pages), not
infrastructure — there's no LIVE-STATE/ROADMAP/ADR set to read here.
