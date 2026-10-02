M = {
  option1 = "option1"
}

function M:message()
  print("Here is the plugin message " .. self.option)
end

return M
