 function nix-clean
    # Define valid options
    argparse 'a/aggressive' 'n/dry-run' 'k/keep=' -- $argv
    or return 1

    # Set defaults or use parsed values
    set -l keep_generations 5
    if set -q _flag_keep
        set keep_generations $_flag_keep
    end

    set -q _flag_dry_run; and set -l dry_run 1; or set -l dry_run 0
    set -q _flag_aggressive; and set -l aggressive 1; or set -l aggressive 0

    if test $dry_run -eq 1
        echo "🔍 Dry-run mode: no changes will be made."
    end

    # Scoped helper for execution
    function __maybe_execute -V dry_run
        if test $dry_run -eq 0
            $argv
        else
            echo "[DRY-RUN] $argv"
        end
    end

    echo "🧹 Starting Nix cleanup (keeping last $keep_generations system/user generations)..."

    # --- System generations (NixOS) ---
    echo "🗑️  System generations:"
    if test $dry_run -eq 0
        set -l old_gens (sudo nix-env -p /nix/var/nix/profiles/system --list-generations 2>/dev/null | tail -n +(math $keep_generations + 1) | wc -l)
        echo "   $old_gens old generations to delete"
    end
    __maybe_execute sudo nix-env -p /nix/var/nix/profiles/system --delete-generations "+$keep_generations"

    # --- User generations ---
    echo "🗑️  User generations:"
    if test $dry_run -eq 0
        set -l old_gens (nix-env --list-generations 2>/dev/null | tail -n +(math $keep_generations + 1) | wc -l)
        echo "   $old_gens old generations to delete"
    end
    __maybe_execute nix-env --delete-generations "+$keep_generations"

    # --- Garbage collection ---
    echo "🗑️  Collecting garbage..."
    __maybe_execute sudo nix-collect-garbage -d

    # --- Cleaning tmp gcroots ---
    echo "🧹 Cleaning temporary GC roots..."
    set -l tmp_gcroot "/nix/var/nix/gcroots/tmp"
    if test -d "$tmp_gcroot"
        set -l broken_count (find "$tmp_gcroot" -type l ! -exec test -e {} \; -print 2>/dev/null | wc -l)
        echo "   Found $broken_count broken temporary GC roots"
        if test $dry_run -eq 0
            find "$tmp_gcroot" -type l ! -exec test -e {} \; -delete 2>/dev/null
        else
            echo "[DRY-RUN] find $tmp_gcroot -type l ! -exec test -e {} \; -delete"
        end
    end

    # --- Aggressive cleanup ---
    if test $aggressive -eq 1
        echo "🧨 Aggressive mode: deleting old boot profiles and channel caches..."
        __maybe_execute sudo find /nix/var/nix/profiles -maxdepth 1 -name 'system-*-link' -type d -mtime +10 -exec rm -rf "{}" +
        __maybe_execute rm -rf ~/.cache/nix/channels
    end

    # --- Optimize store ---
    echo "💎 Optimizing store (deduping)..."
    __maybe_execute sudo nix-store --optimise

    # --- Final stats ---
    if test $dry_run -eq 0
        set -l sys_size (du -sh /nix/store 2>/dev/null | cut -f1)
        echo "✅ Cleanup complete. /nix/store size: $sys_size"
        echo "   Generations kept: $keep_generations (system & user)"
    else
        echo "✅ Dry-run complete."
    end
end
