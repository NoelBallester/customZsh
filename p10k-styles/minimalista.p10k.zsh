# Powerlevel10k config file.
#
# For a comprehensive guide, visit:
# https://github.com/romkatv/powerlevel10k/blob/master/README.md

# Typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

# Tip: If you want to change the order of segments, move them around in
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS and POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS.

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  # =========================[ Line #1 ]=========================
  os_icon                 # os identifier
  dir                     # current directory
  vcs                     # git status
  # =========================[ Line #2 ]=========================
  prompt_char             # prompt symbol
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  # =========================[ Line #1 ]=========================
  status                  # exit code of the last command
  command_execution_time  # duration of the last command
  background_jobs         # presence of background jobs
  time                    # current time
  # =========================[ Line #2 ]=========================
)

# Basic styling.
typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=2
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=1
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND=2
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND=1
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_FOREGROUND=2
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_FOREGROUND=1
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIOWR_FOREGROUND=2
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIOWR_FOREGROUND=1

# OS icon.
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=232
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=7

# Current directory.
typeset -g POWERLEVEL9K_DIR_FOREGROUND=4

# Git status.
typeset -g POWERLEVEL9K_VCS_FOREGROUND=3

# Prompt symbol.
typeset -g POWERLEVEL9K_PROMPT_CHAR_FOREGROUND=5
