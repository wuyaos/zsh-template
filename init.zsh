typeset -A _numpad_map
_numpad_map=(
  "^[Op" 0
  "^[Oq" 1
  "^[Or" 2
  "^[Os" 3
  "^[Ot" 4
  "^[Ou" 5
  "^[Ov" 6
  "^[Ow" 7
  "^[Ox" 8
  "^[Oy" 9
  "^[On" "."
  "^[Oo" "/"
  "^[Oj" "*"
  "^[Om" "-"
  "^[Ok" "+"
)

for _m in emacs viins; do
  for _seq _out in ${(kv)_numpad_map}; do
    bindkey -M "${_m}" -s -- "${_seq}" "${_out}"
  done
  bindkey -M "${_m}" -- "^[OM" accept-line
done

unset _m _seq _out _numpad_map
