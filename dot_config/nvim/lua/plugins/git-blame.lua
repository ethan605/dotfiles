return {
  "f-person/git-blame.nvim",
  config = function()
    local leading_spaces = string.rep(" ", 3)

    require("gitblame").setup({
      delay = 500,

      message_template = leading_spaces .. "<author>, <date> • <summary>",
      date_format = "%d %b %Y",
      message_when_not_committed = leading_spaces .. "• WIP (Not committed yet)",

      schedule_event = "CursorHold",
      clear_event = "CursorHoldI",
    })
  end,
}
