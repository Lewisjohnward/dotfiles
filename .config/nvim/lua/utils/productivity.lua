local M = {}

-- Run test for current file
M.run_test = function()
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    print("No file is currently open")
    return
  end

  local ext = vim.fn.expand("%:e")
  local filename = vim.fn.expand("%:t:r")
  local dir = vim.fn.expand("%:p:h")
  
  -- Determine test file based on language conventions
  local test_file
  
  if ext == "py" then
    test_file = dir .. "/test_" .. filename .. ".py"
  elseif ext == "go" then
    test_file = dir .. "/" .. filename .. "_test.go"
  elseif ext == "rs" then
    test_file = dir .. "/" .. filename .. "_test.rs"
  elseif ext == "js" or ext == "ts" or ext == "jsx" or ext == "tsx" then
    -- Check common test locations
    local possible_tests = {
      dir .. "/" .. filename .. ".test." .. ext,
      dir .. "/__tests__/" .. filename .. ".test." .. ext,
      dir .. "/__tests__/" .. filename .. "." .. ext,
    }
    for _, path in ipairs(possible_tests) do
      if vim.fn.filereadable(path) == 1 then
        test_file = path
        break
      end
    end
  end
  
  if not test_file or vim.fn.filereadable(test_file) == 0 then
    print("No test file found for current file")
    return
  end
  
  -- Run the test based on file type
  local cmd
  if ext == "py" then
    cmd = "pytest " .. vim.fn.shellescape(test_file)
  elseif ext == "go" then
    cmd = "go test " .. vim.fn.shellescape(test_file)
  elseif ext == "rs" then
    cmd = "cargo test --test " .. filename
  elseif ext == "js" or ext == "ts" or ext == "jsx" or ext == "tsx" then
    -- Try to detect test runner
    local package_json = vim.fn.findfile("package.json", ".;")
    if package_json ~= "" then
      local content = vim.fn.readfile(package_json)
      local has_vitest = vim.fn.match(content, "vitest") >= 0
      local has_jest = vim.fn.match(content, "jest") >= 0
      
      if has_vitest then
        cmd = "vitest run " .. vim.fn.shellescape(test_file)
      elseif has_jest then
        cmd = "jest " .. vim.fn.shellescape(test_file)
      else
        cmd = "npm test -- " .. vim.fn.shellescape(test_file)
      end
    else
      cmd = "npm test -- " .. vim.fn.shellescape(test_file)
    end
  end
  
  if cmd then
    -- Open terminal and run the test
    vim.cmd("split | terminal " .. cmd)
  else
    print("Could not determine test command for this file type")
  end
end

-- Insert TODO comment with name and date
M.insert_todo = function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local indent = line:match("^%s*") or ""
  
  local ext = vim.fn.expand("%:e")
  local comment_prefix
  
  -- Determine comment style based on file type
  if ext == "py" or ext == "sh" or ext == "yaml" or ext == "yml" then
    comment_prefix = "#"
  elseif ext == "lua" then
    comment_prefix = "--"
  elseif ext == "html" or ext == "xml" then
    comment_prefix = "<!--"
  else
    comment_prefix = "//"
  end
  
  local date = os.date("%Y-%m-%d")
  local username = vim.fn.expand("$USER")
  local todo = string.format("%s %s TODO(%s %s): ", indent, comment_prefix, username, date)
  
  -- Insert the TODO comment on a new line
  local current_line_num = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, current_line_num, current_line_num, false, { todo })
  
  -- Move cursor to end of TODO line
  vim.api.nvim_win_set_cursor(0, { current_line_num + 1, #todo })
  vim.cmd("startinsert!")
end

-- Insert console.log with variable name
M.insert_console_log = function()
  local mode = vim.fn.mode()
  local var_name
  
  if mode == "v" or mode == "V" then
    -- Get visually selected text
    vim.cmd('normal! "vy')
    var_name = vim.fn.getreg("v")
  else
    -- Get word under cursor
    var_name = vim.fn.expand("<cword>")
  end
  
  if var_name == "" then
    print("No variable selected or under cursor")
    return
  end
  
  local ext = vim.fn.expand("%:e")
  local log_statement
  
  if ext == "js" or ext == "jsx" or ext == "ts" or ext == "tsx" then
    log_statement = string.format('console.log("%s:", %s);', var_name, var_name)
  elseif ext == "py" then
    log_statement = string.format('print(f"%s: {%s}")', var_name, var_name)
  elseif ext == "go" then
    log_statement = string.format('fmt.Printf("%s: %%v\\n", %s)', var_name, var_name)
  elseif ext == "rs" then
    log_statement = string.format('println!("%s: {:?}", %s);', var_name, var_name)
  else
    log_statement = string.format('console.log("%s:", %s);', var_name, var_name)
  end
  
  -- Get current line and indentation
  local current_line = vim.api.nvim_get_current_line()
  local indent = current_line:match("^%s*") or ""
  log_statement = indent .. log_statement
  
  -- Insert on next line
  local current_line_num = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, current_line_num, current_line_num, false, { log_statement })
  
  -- Move cursor to the inserted line
  vim.api.nvim_win_set_cursor(0, { current_line_num + 1, #log_statement })
end


-- Fuzzy find variables to console.log
M.fuzzy_console_log = function()
  local ext = vim.fn.expand("%:e")
  local current_file = vim.fn.expand("%:p")
  local buf = vim.api.nvim_get_current_buf()
  
  -- Get all lines in the buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local variables = {}
  local seen = {}
  
  -- Extract variable names based on file type
  local patterns = {}
  if ext == "js" or ext == "jsx" or ext == "ts" or ext == "tsx" then
    patterns = {
      "const%s+([%w_]+)%s*=",
      "let%s+([%w_]+)%s*=",
      "var%s+([%w_]+)%s*=",
      "function%s+([%w_]+)%s*%(",
      "([%w_]+)%s*:%s*[%w_<>%[%]]+%s*[,;)]",  -- object properties/params
      "([%w_]+)%s*=%s*%(", -- arrow functions
    }
  elseif ext == "py" then
    patterns = {
      "([%w_]+)%s*=",
      "def%s+([%w_]+)%s*%(",
      "class%s+([%w_]+)%s*[:(]",
    }
  elseif ext == "go" then
    patterns = {
      "([%w_]+)%s*:=",
      "var%s+([%w_]+)",
      "func%s+([%w_]+)%s*%(",
    }
  elseif ext == "rs" then
    patterns = {
      "let%s+([%w_]+)%s*=",
      "let%s+mut%s+([%w_]+)%s*=",
      "fn%s+([%w_]+)%s*%(",
    }
  else
    -- Default to JS-like patterns
    patterns = {
      "const%s+([%w_]+)%s*=",
      "let%s+([%w_]+)%s*=",
      "var%s+([%w_]+)%s*=",
    }
  end
  
  -- Extract variables from all lines
  for line_num, line in ipairs(lines) do
    for _, pattern in ipairs(patterns) do
      for var in line:gmatch(pattern) do
        if not seen[var] and var ~= "" then
          seen[var] = true
          table.insert(variables, {
            var_name = var,
            file = current_file,
            buf = buf,
            pos = { line_num, 1 },
            text = var .. " (line " .. line_num .. ")",
          })
        end
      end
    end
  end
  
  if #variables == 0 then
    print("No variables found in current buffer")
    return
  end
  
  -- Use Snacks picker with preview
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    print("Snacks not available")
    return
  end
  
  snacks.picker.pick({
    finder = function(picker, query, opts)
      return variables
    end,
    format = "file",
    confirm = function(picker, item)
      if not item then return end
      
      picker:close()
      
      vim.schedule(function()
        local var_name = item.var_name
        local log_statement
        
        if ext == "js" or ext == "jsx" or ext == "ts" or ext == "tsx" then
          log_statement = string.format('console.log("%s:", %s);', var_name, var_name)
        elseif ext == "py" then
          log_statement = string.format('print(f"%s: {%s}")', var_name, var_name)
        elseif ext == "go" then
          log_statement = string.format('fmt.Printf("%s: %%v\\n", %s)', var_name, var_name)
        elseif ext == "rs" then
          log_statement = string.format('println!("%s: {:?}", %s);', var_name, var_name)
        else
          log_statement = string.format('console.log("%s:", %s);', var_name, var_name)
        end
        
        -- Get current line and indentation
        local current_line = vim.api.nvim_get_current_line()
        local indent = current_line:match("^%s*") or ""
        log_statement = indent .. log_statement
        
        -- Insert on next line
        local current_line_num = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, current_line_num, current_line_num, false, { log_statement })
        
        -- Move cursor to the inserted line
        vim.api.nvim_win_set_cursor(0, { current_line_num + 1, #log_statement })
      end)
    end,
  })
end

return M

