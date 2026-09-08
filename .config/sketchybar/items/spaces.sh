#!/usr/bin/env sh

sketchybar --add event aerospace_workspace_change

# Normally the workspace list comes from AeroSpace, but sketchybar can start
# first (or AeroSpace can be restarted underneath it), which would leave the bar
# with no workspace items at all. Fall back to the workspaces declared in
# aerospace.toml; aerospacer.sh fills in the live state once AeroSpace answers.
WORKSPACES="$(aerospace list-workspaces --all 2>/dev/null)"
if [ -z "$WORKSPACES" ]; then
  # Matches both `workspace 1` and `move-node-to-workspace S` bindings, so named
# workspaces like the scratchpad survive the fallback too.
WORKSPACES="$(grep -oE "(move-node-to-)?workspace [A-Za-z0-9]+'" "$HOME/.config/aerospace/aerospace.toml" 2>/dev/null \
                 | sed "s/.*workspace //; s/'//" | sort -u)"
fi
[ -z "$WORKSPACES" ] && WORKSPACES="1 2 3 4"

for sid in $WORKSPACES; do
    sketchybar --add item "space.$sid" left                                   \
               --subscribe "space.$sid" aerospace_workspace_change            \
                                         front_app_switched               \
               --set "space.$sid"                                             \
                              icon="$sid"                                     \
                              icon.padding_left=10                            \
                              icon.padding_right=6                            \
                              icon.highlight_color=$RED                       \
                              label.font="sketchybar-app-font:Regular:14.0"   \
                              label.padding_left=2                            \
                              label.padding_right=10                          \
                              label.y_offset=-1                               \
                              label.drawing=off                               \
                              background.color=$BACKGROUND_1                  \
                              background.corner_radius=6                      \
                              background.height=26                            \
                              background.drawing=off                          \
                              click_script="aerospace workspace $sid"         \
                              script="$PLUGIN_DIR/aerospacer.sh $sid"
done

sketchybar   --add item       separator left                          \
             --set separator  icon=􀆊                                  \
                              icon.font="$FONT:Heavy:16.0"            \
                              background.padding_left=10              \
                              background.padding_right=10             \
                              label.drawing=off                       \
                              associated_display=active               \
                              icon.color=$OVERLAY1
