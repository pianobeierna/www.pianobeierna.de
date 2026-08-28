---
name: end-session
description: Close a work session on the pianobeierna.de Jekyll site — check for uncommitted changes, commit, and push. Use when wrapping up work here.
disable-model-invocation: true
---

# End Session

Close the session cleanly with all state persisted.

1. **Check for uncommitted changes**: run `git status --short` and review the diff before staging
   anything.
2. **Commit**: stage the relevant files and commit with a short, descriptive message matching this
   repo's existing style (check `git log` for tone/format). No AI-attribution trailers in the
   message.
3. **Push**: if the current branch tracks a remote (`git status -sb` / `git remote -v`), push it.
   This is a PUBLIC GitHub Pages repo (custom domain `www.pianobeierna.de`) — don't stage or push
   anything not meant to be public.
4. **Leave other branches alone**: do not merge, rebase onto, or otherwise touch any branch other
   than the one you were working on (e.g. a pending review branch like `perf-seo`) as part of
   closing this session, unless the owner explicitly asked for it.

Note: this is a lightweight static site, not infrastructure — there's no LIVE-STATE/ROADMAP to
sync, and no separate registry beyond what's already in PIO's project registry.
