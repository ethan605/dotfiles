---@type LazyPluginSpec
return {
  "dlyongemallo/diffview.nvim",
  opts = function()
    local actions = require("diffview.actions")

    ---@type DiffViewOptions
    return {
      diffopt = { algorithm = "histogram" },
      default_args = {
        DiffviewOpen = { "--imply-local" },
      },
      enhanced_diff_hl = false, -- Keep this off for custom per-side colouring below
      -- Persist selection marks (used as "viewed" in the git-review workflow).
      persist_selections = { enabled = true },
      hooks = {
        diff_buf_win_enter = function(_, winid, ctx)
          local layout = ctx.layout_name or ""
          -- Only 2-way + unified single-file layouts have a clean old/new split.
          -- Leave diff1_raw and all merge (diff3_/diff4_) layouts on defaults.
          if layout == "diff1_raw" or not layout:match("^diff[12]_") then
            return
          end

          local function apply(mappings)
            local replaced = {}
            for src in pairs(mappings) do
              replaced[src] = true
            end
            local kept = {}
            for entry in vim.gsplit(vim.wo[winid].winhighlight, ",", {
              plain = true,
              trimempty = true,
            }) do
              local from = entry:match("^([^:]+):")
              if from and not replaced[from] then
                kept[#kept + 1] = entry
              end
            end
            for src, dst in pairs(mappings) do
              kept[#kept + 1] = src .. ":" .. dst
            end
            vim.wo[winid].winhighlight = table.concat(kept, ",")
          end

          if ctx.symbol == "a" then
            -- Old / left pane. A line present only here is DiffAdd (native diff semantics);
            -- DiffDelete is the filler opposite a right-side add.
            apply({
              DiffAdd = "DeltaDiffMinus",
              DiffDelete = "DeltaDiffFiller",
              DiffChange = "DeltaDiffMinus",
              DiffText = "DeltaDiffMinusEmph",
            })
          elseif ctx.symbol == "b" then
            -- New / right pane, and the single window used by diff1_inline.
            apply({
              DiffAdd = "DeltaDiffPlus",
              DiffDelete = "DeltaDiffFiller",
              DiffChange = "DeltaDiffPlus",
              DiffText = "DeltaDiffPlusEmph",
              -- diff1_inline renders via diffview's own extmark groups:
              DiffviewDiffAdd = "DeltaDiffPlus",
              DiffviewDiffDelete = "DeltaDiffMinus",
              DiffviewDiffChange = "DeltaDiffPlus",
              DiffviewDiffTextInline = "DeltaDiffPlusEmph",
            })
          end
        end,
      },
      file_panel = {
        show_branch_name = true,
        always_show_sections = true,
        -- Always show the selection checkbox so "viewed" state is visible.
        always_show_marks = true,
      },
      view = {
        cycle_layouts = {
          default = { "diff2_horizontal", "diff1_inline" },
          merge_tool = { "diff3_horizontal", "diff3_mixed", "diff4_mixed" },
        },
      },
      keymaps = {
        view = {
          { "n", "]g", actions.cycle_layout, { desc = "Cycle through available layouts." } },
        },
      },
    }
  end,
}
