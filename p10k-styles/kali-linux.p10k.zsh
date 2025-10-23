# Powerlevel10k Theme: Kali Linux Style
# Based on the visual appearance of the Kali Linux default prompt.

# General settings
typeset -g POWERLEVEL9K_MODE='nerdfont-complete'
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Left prompt elements: os_icon, directory, and version control
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)

# Right prompt elements: status, command execution time, and time
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)

# --- Styling for Left Prompt ---

# OS Icon segment (Kali Dragon)
typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='ﴣ' # Nerd Font icon for Kali Linux
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='161'     # Purple background
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='231'     # White foreground

# Directory segment
typeset -g POWERLEVEL9K_DIR_BACKGROUND='125'         # Dark red background
typeset -g POWERLEVEL9K_DIR_FOREGROUND='231'         # White foreground
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='231'
typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true

# Version control segment
typeset -g POWERLEVEL9K_VCS_BACKGROUND='236'         # Dark grey background
typeset -g POWERLEVEL9K_VCS_FOREGROUND='248'         # Light grey foreground

# --- Styling for Right Prompt ---

# Status segment (shows exit code of last command)
typeset -g POWERLEVEL9K_STATUS_BACKGROUND='236'      # Dark grey background
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='40'    # Green foreground for success
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='196'# Red foreground for error

# Command execution time segment
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='236'
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='248'

# Time segment
typeset -g POWERLEVEL9K_TIME_BACKGROUND='236'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='248'
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'

# --- Prompt Character Styling ---
typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='125'
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_FOREGROUND='40'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_FOREGROUND='196'
typeset -g POWERLEVEL9K_PROMPT_CHAR_SYMBOL='❯'

# --- Visual Connection between Segments ---
# Defines the separator shape between segments.
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
