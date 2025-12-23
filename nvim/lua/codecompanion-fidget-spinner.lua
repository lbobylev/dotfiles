local progress = require("fidget.progress")

local M = {}

M.handles = {}

function M:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(ev)
      local handle = M:create_progress_handle(ev)
      M:store_progress_handle(ev.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(ev)
      local handle = M:pop_progress_handle(ev.data.id)
      if handle then
        M:report_exit_status(handle, ev)
        handle:finish()
      end
    end,
  })
end

function M:store_progress_handle(id, handle)
  self.handles[id] = handle
end

function M:pop_progress_handle(id)
  local handle = self.handles[id]
  self.handles[id] = nil
  return handle
end

function M:create_progress_handle(ev)
  local adapter = ev.data.adapter or {}
  local interaction = ev.data.interaction or "request"

  return progress.handle.create({
    title = " Requesting assistance (" .. interaction .. ")",
    message = "In progress...",
    lsp_client = { name = self:llm_role_title(adapter) },
  })
end

function M:llm_role_title(adapter)
  local parts = {}

  if adapter.formatted_name and adapter.formatted_name ~= "" then
    table.insert(parts, adapter.formatted_name)
  elseif adapter.name and adapter.name ~= "" then
    table.insert(parts, adapter.name)
  else
    table.insert(parts, "LLM")
  end

  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")")
  end

  return table.concat(parts, " ")
end

function M:report_exit_status(handle, ev)
  local status = ev.data.status
  if status == "success" then
    handle.message = "Completed"
  elseif status == "error" then
    handle.message = " Error"
  else
    handle.message = "󰜺 Cancelled"
  end
end

return M
