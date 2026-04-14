function view
  if command -q bat
    bat --paging=always $argv
  else
    cat $argv | less &
  end
end
