set -U pure_prompt_symbol ">"

function fish_prompt
  if test $status -eq 0
    echo
    set_color green
  else
    echo
    set_color red
  end
  echo ""(set_color blue) @(basename @$PWD)": "
end

function fish_greeting
end
