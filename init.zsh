# Prefer a conda-compatible command in this order:
# conda > micromamba > mamba
if (( ${+commands[conda]} )); then
  :
elif (( ${+commands[micromamba]} )); then
  alias conda=micromamba
elif (( ${+commands[mamba]} )); then
  alias conda=mamba
else
  return 0
fi

alias cna='conda activate'
alias cnab='conda activate base'
alias cnde='conda deactivate'
alias cnel='conda env list'
alias cnl='conda list'
alias cni='conda install'
alias cnr='conda remove'
alias cnu='conda update'

conda_prompt_info() {
  [[ -n ${CONDA_DEFAULT_ENV} ]] || return
  echo "${ZSH_THEME_CONDA_PREFIX=[}${CONDA_DEFAULT_ENV:t:gs/%/%%}${ZSH_THEME_CONDA_SUFFIX=]}"
}

# Keep prompt ownership in p10k instead of conda itself.
export CONDA_CHANGEPS1=false
