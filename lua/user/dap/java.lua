local M = {}

local jdtls_ok, jdtls = pcall(require, "jdtls")

if not jdtls_ok then
  return
end

local json_decode = vim.json and vim.json.decode or vim.fn.json_decode

local function load_configurations(path)
  local resolved_path = path or (vim.fn.getcwd() .. "/.vscode/java-test.json")
  if not vim.loop.fs_stat(resolved_path) then
    return {}
  end

  local lines = {}
  for line in io.lines(resolved_path) do
    if not vim.startswith(vim.trim(line), "//") then
      table.insert(lines, line)
    end
  end

  local contents = table.concat(lines, "\n")
  local data = json_decode(contents)

  return data and data.configurations
end

local function select_config(callback)
  local configurations = load_configurations()
  local names = {}
  local configs = {}

  if configurations == nil or vim.tbl_count(configurations) == 0 then
    callback(nil)
    return
  end

  for _, c in pairs(configurations) do
    local name = c.name
    c.name = nil

    table.insert(names, name)
    configs[name] = c
  end

  if vim.tbl_count(configs) == 1 then
    callback(vim.tbl_values(configs)[0])
    return
  end

  local opts = {}
  vim.ui.select(names, opts, function(name)
    callback(configs[name])
  end)
end

M.test_nearest_method = function()
  select_config(function(config)
    if config == nil then
      jdtls.test_nearest_method()
      return
    end

    jdtls.test_nearest_method({ config_overrides = config })
  end)
end

M.test_class = function()
  select_config(function(config)
    if config == nil then
      jdtls.test_class()
      return
    end

    jdtls.test_class({ config_overrides = config })
  end)
end

return M
