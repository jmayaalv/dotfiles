-- In Rex, Karabiner makes left Command Meta and left Control a second
-- Command, like the right one (Caps Lock is Control; the alt key is broken).
-- Rex's own cmd shortcuts stay; the ones below replace a few defaults.

-- cmd+arrows move between panes (replace Jump to Previous/Next Prompt);
-- shift+cmd+arrows split a new pane that way (also Rex's Split Pane menu
-- shortcuts, which win over this file); ctrl+cmd+arrows (Caps Lock+cmd) move
-- the pane, since Rex's alt+shift+cmd+arrows need the broken alt key.
for _, d in ipairs({ "left", "right", "up", "down" }) do
  rex.bind("cmd+" .. d, "pane.focus", { direction = d })
  rex.bind("shift+cmd+" .. d, "pane.split", { direction = d })
  rex.bind("ctrl+cmd+" .. d, "pane.move", { direction = d })
end

-- cmd+[ / ]: previous / next session, in sidebar order (replace Focus
-- Previous/Next Pane).
rex.bind("cmd+[", "session.previous")
rex.bind("cmd+]", "session.next")

-- Close: cmd+w the pane (default); shift+cmd+w the tab (replaces Close Window,
-- since the default alt+cmd+w needs the broken alt key); ctrl+cmd+w (Caps
-- Lock+cmd) the session, which has no default. Close Window stays in the
-- palette: shift+cmd+q, the wanted key for it, is macOS's Log Out.
rex.bind("shift+cmd+w", "client.tab.close")
rex.bind("ctrl+cmd+w", "session.close")

-- shift+cmd+t renames the tab (Rename Tab has no default key).
rex.bind("shift+cmd+t", "client.tab.rename")

-- The folder of the program in the action's pane. These shells don't report
-- theirs to Rex, so the terminal's `pwd` is empty.
local function pane_folder(ctx)
  local p = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  return p and p.foreground and p.foreground.cwd or os.getenv("HOME")
end

-- ctrl+cmd+n (Caps Lock+cmd): New Worktree. A floating pane in the focused
-- pane's folder asks for a branch; rex/new-worktree makes the worktree with
-- worktrunk and opens a session there (~/Developer/rex-new-worktree).
rex.action{
  name  = "new_worktree",
  title = "New Worktree…",
  run   = function(ctx)
    local _, err = rex.session.new_layer{
      bounds = { 0.3, 0.4, 0.4, 0.12 },  -- about 78x8 on a full 196x69 window
      focus  = true,
      layout = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        options = {
          cwd     = pane_folder(ctx),
          command = { os.getenv("HOME") .. "/.config/rex/new-worktree", ctx.client_id or "" },
          -- wt lives here; brew shellenv runs only in .zshrc, which a command pane skips.
          path_prepend = { "/opt/homebrew/bin" },
        },
      },
    }
    if err ~= nil then error(err, 0) end
  end,
}
rex.bind("ctrl+cmd+n", "new_worktree")

-- tuicr review of a pane's uncommitted changes in a pane on its right
-- (rex/tuicr-review, ~/Developer/rex-tuicr). When tuicr quits, the comments new
-- or edited in it go back to the pane's agent: shift+cmd+d pastes them into its
-- input, unsent (replaces Split Pane Down; shift+cmd+down still splits). The
-- submit variant, palette only, also presses Enter. A pane with no agent (a
-- shell, Emacs) gets nothing typed: its comments go to the clipboard.
local function tuicr_review(mode)
  return function(ctx)
    local st = rex.block.call("com.superlogical.terminal", "program_status", { block_id = ctx.block_id })
    local agent = st and st.records and #st.records > 0
    local how = agent and mode or "clipboard"
    local _, err = rex.session.new_split{
      anchor_id = ctx.block_id,
      direction = "horizontal",
      side      = "after",
      focus     = true,
      layout    = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        label   = "tuicr",
        options = {
          cwd          = pane_folder(ctx),
          command      = { os.getenv("HOME") .. "/.config/rex/tuicr-review", how, ctx.session_id, ctx.block_id },
          path_prepend = { "/opt/homebrew/bin" },  -- tuicr and node, as for wt above
        },
      },
    }
    if err ~= nil then error(err, 0) end
  end
end
rex.action{ name = "tuicr_review_paste", title = "Review Changes in tuicr (paste comments)", run = tuicr_review("paste") }
rex.action{ name = "tuicr_review_submit", title = "Review Changes in tuicr (submit comments)", run = tuicr_review("submit") }
rex.bind("shift+cmd+d", "tuicr_review_paste")

-- shift+cmd+j: hints over the focused pane (rex/hints) in a floating pane laid
-- exactly over it. Type a hint, then c copy, o open, e edit (ec in a split),
-- t edit in a tab, m move (a click there). Repo: ~/Developer/rex-hints.
local function find_rect(node, id)
  if node.block_id == id then return node.rect end
  if node.split then return find_rect(node.split.before, id) or find_rect(node.split.after, id) end
end

-- The picker over ctx's pane; mode "jump" is the ace-jump variant below.
local function open_hints(ctx, mode)
  local view, err = rex.session.view{}
  if view == nil then error(err, 0) end
  for _, w in ipairs(view.windows) do
    for _, layer in ipairs(w.layers) do
      local rect = layer.layout and find_rect(layer.layout, ctx.block_id)
      if rect then
        local size = rex.block.call("com.superlogical.terminal", "size", { block_id = ctx.block_id }) or {}
        local _, e = rex.session.new_layer{
          window_id = w.window_id,
          bounds    = rect,  -- layout rects are window fractions in every layer
          focus     = true,  -- ends a zoom; hints puts it back (the "1" below)
          layout    = rex.layout.block{
            flavor  = "com.superlogical.terminal.shell",
            label   = "hints",
            options = {
              cwd          = pane_folder(ctx),
              command      = { os.getenv("HOME") .. "/.config/rex/hints", ctx.session_id, ctx.block_id,
                               w.zoomed_block_id == ctx.block_id and "1" or "0", mode },
              path_prepend = { "/opt/homebrew/bin" },  -- node, as for wt above
              size         = size.columns and { columns = size.columns, rows = size.rows } or nil,
            },
          },
        }
        if e ~= nil then error(e, 0) end
        return
      end
    end
  end
  error("Hints: the focused pane isn't in this session's layout.", 0)
end

rex.action{ name = "hints", title = "Hints: Copy, Open, Edit or Move…", run = function(ctx) open_hints(ctx, "items") end }
rex.bind("shift+cmd+j", "hints")

-- ctrl+cmd+j (Caps Lock+cmd): ace-jump. Type a word's first character, then
-- its hint; the cursor goes there (a click, as Move does). One match jumps at once.
rex.action{ name = "jump", title = "Jump to a Word…", run = function(ctx) open_hints(ctx, "jump") end }
rex.bind("ctrl+cmd+j", "jump")

-- Resize mode: cmd+r (replaces Refresh Sessions), then arrows (shift for
-- bigger steps), = balances, esc/enter leaves.
rex.mode("resize", { exclusive = true })
rex.bind("cmd+r", "client.mode.enter", { name = "resize" })

for _, d in ipairs({ "left", "right", "up", "down" }) do
  rex.bind("resize/" .. d, "pane.resize", { direction = d })
  rex.bind("resize/shift+" .. d, "pane.resize", { direction = d, amount = 15 })
end
rex.bind("resize/=",      "pane.balance")
rex.bind("resize/escape", "client.mode.exit")
rex.bind("resize/enter",  "client.mode.exit")

-- Right Option is Super for Emacs, never a Rex shortcut: Karabiner sends it as
-- ctrl+alt+cmd, which nothing here binds, so the program gets C-M-s-<key> and
-- ~/.emacs.d/personal/terminal.el turns that into s-<key>. (Re-sending keys
-- with pane.send_key doesn't work: it drops cmd+letter.)
