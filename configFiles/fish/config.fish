function fish_greeting\
    --description="Fish-shell colorful ASCII-art logo" \
    --argument-names outer_color medium_color inner_color mouth eye

    # defaults:
    [ $outer_color  ]; or set outer_color  'red'
    [ $medium_color ]; or set medium_color 'f70'
    [ $inner_color  ]; or set inner_color  'yellow'
    [ $mouth ]; or set mouth '['
    [ $eye   ]; or set eye   'O'

    set usage 'Usage: fish_logo <outer_color> <medium_color> <inner_color> <mouth> <eye>
See set_color --help for more on available colors.'

    if contains -- $outer_color '--help' '-h' '-help'
        echo $usage
        return 0
    end

    # shortcuts:
    set o (set_color $outer_color)
    set m (set_color $medium_color)
    set i (set_color $inner_color)

    if test (count $o) != 1; or test (count $m) != 1; or test (count $i) != 1
        echo 'Invalid color argument'
        echo $usage
        return 1
    end

    echo '                 '$o'___
   ___======____='$m'-'$i'-'$m'-='$o')
 /T            \_'$i'--='$m'=='$o')
 '$mouth' \ '$m'('$i$eye$m')   '$o'\~    \_'$i'-='$m'='$o')
  \      / )J'$m'~~    '$o'\\'$i'-='$o')
   \\\\___/  )JJ'$m'~'$i'~~   '$o'\)
    \_____/JJJ'$m'~~'$i'~~    '$o'\\
    '$m'/ '$o'\  '$i', \\'$o'J'$m'~~~'$i'~~     '$m'\\
   (-'$i'\)'$o'\='$m'|'$i'\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_
   '$m'('$o'\\'$m'\\)  ('$i'\\'$m'\\\)'$o'_           '$i'\=='$m'__
    '$o'\V    '$m'\\\\'$o'\) =='$m'=_____   '$i'\\\\\\\\'$m'\\\\
           '$o'\V)     \_) '$m'\\\\'$i'\\\\JJ\\'$m'J\)
                       '$o'/'$m'J'$i'\\'$m'J'$o'T\\'$m'JJJ'$o'J)
                       (J'$m'JJ'$o'| \UUU)
                        (UU)'(set_color normal)
end

function fish_mode_prompt
  switch $fish_bind_mode
    case default
        set_color --bold red
        echo -n '[N]'
    case insert
        set_color --bold green
        echo -n '[I]'
    case replace_one
        set_color --bold green
        echo -n '[R]'
    case replace
        set_color --bold cyan
        echo -n '[R]'
    case visual
        set_color --bold magenta
        echo -n '[V]'
    case '*'
        set_color --bold red
        echo -n '[?]'
  end
  set_color normal
end

set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1
set -g __fish_git_prompt_showstashstate 1

set -g __fish_git_prompt_color_branch blue
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "+"
set -g __fish_git_prompt_char_upstream_behind "-"
set -g __fish_git_prompt_char_upstream_prefix " "
set -g __fish_git_prompt_char_upstream_diverged '<>'
set -g __fish_git_prompt_char_upstream_equal '=='

set -g __fish_git_prompt_char_stateseparator " "

set -g __fish_git_prompt_char_stagedstate "#"
set -g __fish_git_prompt_char_dirtystate "!"
set -g __fish_git_prompt_char_conflictedstate "x"
set -g __fish_git_prompt_char_cleanstate "="
set -g __fish_git_prompt_char_untrackedfiles " ..."

set -g __fish_git_prompt_color_dirtystate f70
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green
set -g __fish_git_prompt_char_stashstate ' s'
set -g __fish_git_prompt_color_stashstate red

function fish_prompt
    # for some reason (fish_git_prompt "\0") doesnt work when called from echo
    echo -sn (tput setaf 6) (tput bold)'━┳━[ '(tput setaf 2) $USER (tput setaf 6)' @ '(tput setaf 2) $hostname (tput setaf 6)' ]━━[ '(tput setaf 4) (prompt_pwd) (tput setaf 6)' ]━━[ ' (fish_git_prompt | cut -c3- | rev | cut -c3- | rev) (tput bold) (tput setaf 6)' ]'\n'    ┗━━━━━ '(tput sgr0)
end
