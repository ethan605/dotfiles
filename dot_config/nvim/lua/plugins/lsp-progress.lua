local function stringify(name, msg)
  return msg and string.format("%s %s", name, msg) or name
end

return {
  "linrongbin16/lsp-progress.nvim",
  opts = {
    format = function(client_messages)
      local sign = " "

      if #client_messages > 0 then
        return table.concat(client_messages, " ") .. sign
      end

      local lsp_clients = vim.lsp.get_clients()

      if #lsp_clients > 0 then
        local builder = {}

        for _, cli in ipairs(lsp_clients) do
          if type(cli) == "table" and type(cli.name) == "string" and string.len(cli.name) > 0 then
            table.insert(builder, stringify(cli.name))
          end
        end

        if #builder > 3 then
          return "(" .. #builder .. ")" .. sign
        end

        if #builder > 0 then
          return table.concat(builder, ", ") .. sign
        end
      end
      return ""
    end,
  },
}
