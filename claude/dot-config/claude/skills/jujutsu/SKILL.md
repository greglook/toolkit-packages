---
name: jujutsu
description: Work with repositories using the Jujutsu version-control tool. Use this when the project contains a `.jj` directory in the top level.
---

If a project contains a `.jj` directory, then it is using [Jujutsu](https://www.jj-vcs.dev/latest/)
for version control, not Git! You **must** use `jj` commands to interact with
the repository and never `git`.

Notify the user if you've decide to use Jujutsu for a session.


## Example Commands

- Check status: `jj st --no-pager`
- View history: `jj log --no-pager`
- Create a new commit to work on: `jj new -m "message"` This is equivalent to starting a new branch in git.
- Split current changes into multiple smaler commits: `jj split -m "message" [FILESETS]`
    - **NEVER** restore files to exclude them from a commit.
- Push: `jj git push`
- Push main: `jj bookmark set main -r @- && jj git push`
- Undo last jj command: `jj undo`
- Help: `jj help`
