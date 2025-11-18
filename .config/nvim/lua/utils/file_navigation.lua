local templates = require("utils.templates")

local M = {}

-- Open or create test file for current file
M.open_test_file = function()
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    print("No file is currently open")
    return
  end

  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t:r")
  local ext = vim.fn.expand("%:e")
  
  -- Determine test file path based on common conventions
  local test_file
  
  -- Check if we're already in a test file
  if filename:match("_test$") or filename:match("%.test$") or filename:match("_spec$") or filename:match("%.spec$") then
    -- If already in test, go to the source file
    local source_name = filename:gsub("_test$", ""):gsub("%.test$", ""):gsub("_spec$", ""):gsub("%.spec$", "")
    
    -- Try to find source file in common locations
    local possible_paths = {
      dir:gsub("/tests?/", "/"):gsub("/test/", "/"):gsub("/__tests__/", "/") .. "/" .. source_name .. "." .. ext,
      dir:gsub("/tests?/", "/src/"):gsub("/test/", "/src/") .. "/" .. source_name .. "." .. ext,
      dir .. "/../" .. source_name .. "." .. ext,
    }
    
    for _, path in ipairs(possible_paths) do
      if vim.fn.filereadable(path) == 1 then
        test_file = path
        break
      end
    end
    
    if not test_file then
      test_file = possible_paths[1]
    end
  else
    -- Create test file path based on language conventions
    local test_dir = dir
    local test_name = filename
    
    -- Language-specific test naming
    if ext == "py" then
      test_name = "test_" .. filename
    elseif ext == "go" then
      test_name = filename .. "_test"
    elseif ext == "rs" then
      test_name = filename .. "_test"
    elseif ext == "js" or ext == "ts" or ext == "jsx" or ext == "tsx" then
      -- Check if there's a __tests__ directory
      local tests_dir = dir .. "/__tests__"
      if vim.fn.isdirectory(tests_dir) == 1 then
        test_dir = tests_dir
      end
      test_name = filename .. ".test"
    else
      test_name = filename .. "_test"
    end
    
    test_file = test_dir .. "/" .. test_name .. "." .. ext
  end
  
  -- Create directory if it doesn't exist
  local test_dir_path = vim.fn.fnamemodify(test_file, ":h")
  if vim.fn.isdirectory(test_dir_path) == 0 then
    vim.fn.mkdir(test_dir_path, "p")
  end
  
  -- Open the test file
  vim.cmd("edit " .. test_file)
  
  -- If file is new, add a basic template
  if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
    local template = nil
    
    if ext == "ts" or ext == "tsx" then
      template = templates.test_typescript(filename, filename)
    elseif ext == "js" or ext == "jsx" then
      template = templates.test_javascript(filename, filename)
    elseif ext == "py" then
      template = templates.test_python(filename)
    end
    
    if template then
      local lines = vim.split(template, "\n")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      print("Created new test file with template: " .. test_file)
    else
      print("Created new test file: " .. test_file)
    end
  end
end

-- Open or create Storybook story file for current file
M.open_story_file = function()
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    print("No file is currently open")
    return
  end

  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t:r")
  local ext = vim.fn.expand("%:e")
  
  -- Determine story file path
  local story_file
  
  -- Check if we're already in a story file
  if filename:match("%.stories$") or filename:match("%.story$") then
    -- If already in story, go to the source file
    local source_name = filename:gsub("%.stories$", ""):gsub("%.story$", "")
    
    -- Try to find source file in common locations
    local possible_exts = {ext, "tsx", "jsx", "ts", "js"}
    local possible_paths = {}
    
    for _, e in ipairs(possible_exts) do
      table.insert(possible_paths, dir .. "/" .. source_name .. "." .. e)
      table.insert(possible_paths, dir:gsub("/stories/", "/") .. "/" .. source_name .. "." .. e)
      table.insert(possible_paths, dir:gsub("/stories/", "/components/") .. "/" .. source_name .. "." .. e)
      table.insert(possible_paths, dir .. "/../" .. source_name .. "." .. e)
    end
    
    for _, path in ipairs(possible_paths) do
      if vim.fn.filereadable(path) == 1 then
        story_file = path
        break
      end
    end
    
    if not story_file then
      story_file = possible_paths[1]
    end
  else
    -- Create story file path
    local story_dir = dir
    local story_name = filename .. ".stories"
    
    -- Check if there's a stories directory
    local stories_dir = dir .. "/stories"
    if vim.fn.isdirectory(stories_dir) == 1 then
      story_dir = stories_dir
    end
    
    -- Use appropriate extension for story files
    local story_ext = ext
    if ext == "jsx" or ext == "js" then
      story_ext = "jsx"
    elseif ext == "tsx" or ext == "ts" then
      story_ext = "tsx"
    end
    
    story_file = story_dir .. "/" .. story_name .. "." .. story_ext
  end
  
  -- Create directory if it doesn't exist
  local story_dir_path = vim.fn.fnamemodify(story_file, ":h")
  if vim.fn.isdirectory(story_dir_path) == 0 then
    vim.fn.mkdir(story_dir_path, "p")
  end
  
  -- Open the story file
  vim.cmd("edit " .. story_file)
  
  -- If file is new, add a basic template
  if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
    local component_name = filename:gsub("%.stories$", ""):gsub("%.story$", "")
    local template = templates.storybook(component_name)
    local lines = vim.split(template, "\n")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    print("Created new story file with template: " .. story_file)
  end
end

return M
