function nix-clean
  set -l keep_generations 5
  set -l aggressive 0
  set -l dry_run 0

  # Parse flags
  argparse 'aggressive' 'dry-run/n' 'keep/k=' -- $argv
  or return

  if set -q _flag_aggressive
    set aggressive 1
  end
  if set -q _flag_dry_run
    set dry_run 1
  end
  if set -q _flag_keep
    set keep_generations $_flag_keep
  end

  if test $dry_run -eq 1
    echo "🔍 Dry-run mode: no changes will be made."
  end

  echo "🧹 Starting Nix cleanup (keeping last $keep_generations system/user generations)..."

  # System generations (NixOS)
  echo "🗑️ System generations:"
  if test $dry_run -eq 0
    sudo nix-env -p /nix/var/nix/profiles/system --list-generations 2>/dev/null \
      | tail -n +(( $keep_generations + 1 )) \
      | wc -l | xargs -I{} echo " {} old generations to delete"
  end

  if test $dry_run -eq 0
    sudo nix-env -p /nix/var/nix/profiles/system --delete-generations "+$keep_generations"
  else
    echo "[DRY-RUN] sudo nix-env -p /nix/var/nix/profiles/system --delete-generations \"+$keep_generations\""
  end

  # User generations
  echo "🗑️ User generations:"
  if test $dry_run -eq 0
    nix-env --list-generations 2>/dev/null \
      | tail -n +(( $keep_generations + 1 )) \
      | wc -l | xargs -I{} echo " {} old generations to delete"
  end

  if test $dry_run -eq 0
    nix-env --delete-generations "+$keep_generations"
  else
    echo "[DRY-RUN] nix-env --delete-generations \"+$keep_generations\""
  end

  # Garbage collection
  echo "🗑️ Collecting garbage..."
  if test $dry_run -eq 0
    sudo nix-collect-garbage -d
  else
    echo "[DRY-RUN] sudo nix-collect-garbage -d"
  end

  # Clean temporary GC roots
  echo "🧹 Cleaning temporary GC roots..."
  if test $dry_run -eq 0
    set tmp_gcroot "/nix/var/nix/gcroots/tmp"
    if test -d "$tmp_gcroot"
      set broken_count (find "$tmp_gcroot" -type l ! -exec test -e {} \; -print | wc -l)
      echo " Found $broken_count broken temporary GC roots"
      find "$tmp_gcroot" -type l ! -exec test -e {} \; -delete 2>/dev/null
    end
  else
    echo "[DRY-RUN] find /nix/var/nix/gcroots/tmp -type l ! -exec test -e {} \; -delete"
  end

  # Aggressive mode
  if test $aggressive -eq 1
    echo "🧨 Aggressive mode: deleting old boot profiles and channel caches..."
    if test $dry_run -eq 0
      sudo find /nix/var/nix/profiles -maxdepth 1 -name 'system-*-link' -type d -mtime +10 -exec rm -f {} \; 2>/dev/null
      rm -rf ~/.cache/nix/channels 2>/dev/null
    else
      echo "[DRY-RUN] sudo find /nix/var/nix/profiles -name 'system-*-link' -mtime +10 -delete"
      echo "[DRY-RUN] rm -rf ~/.cache/nix/channels"
    end
  end

  # Optimize store
  echo "💎 Optimizing store (deduping)..."
  if test $dry_run -eq 0
    sudo nix-store --optimise
  else
    echo "[DRY-RUN] sudo nix-store --optimise"
  end

  # Final stats
  if test $dry_run -eq 0
    set sys_size (du -sh /nix/store 2>/dev/null | cut -f1)
    echo "✅ Cleanup complete. /nix/store size: $sys_size"
    echo " Generations kept: $keep_generations (system & user)"
  else
    echo "✅ Dry-run complete."
  end
end
