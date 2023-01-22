local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

local home = os.getenv "HOME"
local checkstyleJar = home .. "/code/checkstyle/checkstyle.jar"
local checkstyleConfig = home .. "/code/checkstyle/checkstyle.xml"

local severities = {
  ["ERR"] = 1,
  ["ERROR"] = 1,
  ["WARN"] = 2,
  ["INFO"] = 3,
  ["HINT"] = 4
}
local overrides = {
  severities = severities
}

local basename = function(path)
  local name = string.gsub(path, "(.*/)(.*)", "%2")
  return name
end

local create_temp_file = function(path, content)
  local tmp = io.open(path, "w+")
  tmp:write(content)
  tmp:close()
end

function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then io.close(f) return true else return false end
end

local resolve_checkststyle_path = function()
  local project_config = vim.fn.getcwd() .. '/checkstyle.xml'
  if file_exists(project_config) then
    return project_config
  end
  return checkstyleConfig
end

local resolve_args = function(params)
  local filename = basename(params.bufname)
  local path = "/tmp/" .. filename;
  local config = resolve_checkststyle_path()

  create_temp_file(path, table.concat(params.content, "\n"))

  return {
    "-jar", checkstyleJar,
    "-c", config,
    path
  }
end

local checkstyle = {
  name = "checkstyle",
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "java" },
  generator = null_ls.generator({
    command = "java",
    args = resolve_args,
    to_stdin = false,
    ignore_stderr = true,
    format = "line",
    check_exit_code = function()
      return true
    end,
    on_output = helpers.diagnostics.from_patterns({
      {
        pattern = [[^%[(%a+)%] .*:(%d+):(%d+): (.*)$]],
        groups = { "severity", "row", "col", "message" },
        overrides = overrides
      },
      {
        pattern = [[^%[(%a+)%] .*:(%d+): (.*)$]],
        groups = { "severity", "row", "message" },
        overrides = overrides
      },
    }),
  })
}

null_ls.register({ checkstyle })
