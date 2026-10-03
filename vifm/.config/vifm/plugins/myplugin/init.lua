M = {
  pname = "MyPlugin",
  version = "v0.1.0",
  description = "Description",
}

function M:message()
  vifm.sb.info("Running plugin " .. self.name .. " version " .. self.version)
end

function M:menu()
  vifm.menus.loadcustom({
    title = "Menu",
    items = {"One", "Two", "Three"},
  })
end

function M:callback(event)
  -- Doing this will freeze the UI, this heavily suggest that plugins are run
  -- synchronously in the main thread
  -- while true
  -- do
  -- end
  vifm.sb.info(event.op .. "ing " .. "path: " .. event.path)
end

vifm.cmds.add({
  name = M.pname,
  description = M.description,
  handler = function()
    M:menu()
  end
})

vifm.events.listen({
  event = "app.fsop",
  handler = function(event)
    M:callback(event)
  end
})

return M
