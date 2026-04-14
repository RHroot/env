function git-clean
  set -l RED (set_color red)
  set -l GREEN (set_color green)
  set -l YELLOW (set_color yellow)
  set -l BLUE (set_color blue)
  set -l RESET (set_color normal)

  if not test -d .git
    echo "$RED❌ Not inside a Git repository.$RESET"
    return 1
  end

  if test (count $argv) -gt 0
    switch $argv[1]
      case --hard
        echo "$YELLOW⚠️ HARD CLEANUP: This rewrites history and may break shared repos.$RESET"
        echo " Backup first! Press Ctrl+C to abort."

        # Safety checks
        if not git diff --quiet
          echo "$RED❌ You have uncommitted changes. Commit or stash them first.$RESET"
          return 1
        end

        set untracked (git ls-files --others --exclude-standard)
        if test -n "$untracked"
          echo "$RED❌ You have untracked files:$RESET"
          echo "$untracked"
          return 1
        end

        set unpushed (git log --branches --not --remotes --oneline)
        if test -n "$unpushed"
          echo "$RED❌ You have commits not pushed to any remote:$RESET"
          echo "$unpushed" | less -S
          return 1
        end

        read --prompt-str="Continue with hard cleanup? (y/N) " confirm
        if not string match -qi y $confirm
          echo "$RED❎ Aborted hard cleanup.$RESET"
          return 0
        end

        # Check for large files
        set large_files (git rev-list --objects --all \
          | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
          | awk '$1 == "blob" && $3 > 10485760 {printf "%.2f MB\t%s\n", $3/1048576, $4}')

        if test -n "$large_files"
          echo "$RED🚨 Large files found in history:$RESET"
          echo "$large_files" | less -S
        else
          echo "$GREEN✅ No blobs larger than 10MB found.$RESET"
        end

        if command -q git-filter-repo
          git filter-repo --strip-blobs-bigger-than 10M --force
          echo "$GREEN✅ git-filter-repo cleanup complete.$RESET"
        else if command -q bfg
          bfg --strip-blobs-bigger-than 10M
          git reflog expire --expire=now --all
          git gc --prune=now --aggressive
          echo "$GREEN✅ BFG cleanup complete.$RESET"
        else
          echo "$RED❌ Neither git-filter-repo nor BFG installed. Cannot do hard cleanup.$RESET"
        end

      case '*'
        echo "$REDUnknown option: $argv[1]$RESET"
        echo "Usage: git-clean [--hard]"
        return 1
    end
  else
    echo "$BLUE🧹 Performing safe cleanup...$RESET"
    git reflog expire --expire=now --all
    git gc --prune=now --aggressive
    echo "$GREEN✅ Safe cleanup complete!$RESET"
  end
end
