-- local dap = require("dap")
-- local M = {}

-- function M.execute_buf_command(command, callback)

--     vim.lsp.buf_request(
--         0, 'workspace/executeCommand', command, function(err, _, res)
--             if callback then
--                 callback(err, res)
--             elseif err then
--                 print('Execute command failed: ' .. err.message)
--             end
--         end)
-- end

-- function M.execute_command(command, callback)
--     if type(command) == 'string' then command = { command = command } end

--     M.execute_buf_command(
--         command, function(err, res)
--             assert(not err, err and (err.message or print(vim.inspect(err))))
--             callback(res)
--         end)
-- end

-- --[[
-- -- Starts the dubug session and returns the port
-- --
-- -- @Param callback {function(port: number)}
-- --]]
-- function M.start_debug_session(callback)
--     M.execute_command('vscode.java.startDebugSession', callback)
-- end

-- --[[
-- -- Returns all the main classes in the project
-- --
-- -- @Param callback {function(main_classes: List<List<String>)}
-- -- { {
-- --     filePath = "/home/s1n7ax/Workspace/demo/src/main/java/com/example/demo/DemoApplication.java",
-- --     mainClass = "com.example.demo.DemoApplication",
-- --     projectName = "demo"
-- -- } }
-- --]]
-- function M.resolve_main_classes(callback)
--     M.execute_command('vscode.java.resolveMainClass', callback)
-- end

-- --[[
-- -- Returns classpath for the given main class
-- --
-- -- @Param main_class {string} of which classpath should be returned
-- -- @Param callback {function(classpath: List<List<String>>)}
-- -- { {},
-- -- {
-- --     "/home/s1n7ax/Workspace/demo/bin/main",
-- --     "/home/s1n7ax/.gradle/.../spring-boot-starter-web/2.5.4/2bef2cedf/spring-boot-starter-web-2.5.4.jar",
-- -- }
-- --]]
-- function M.resolve_class_path(main_class, project_name, callback)
--     M.execute_command(
--         {
--             command = 'vscode.java.resolveClasspath',
--             arguments = { main_class, project_name },
--         }, callback)
-- end

-- --[[
-- -- Returns list of main class and classpath map
-- --
-- -- @Param callback {function(classpaths: List<Map>)}
-- --]]
-- function M.resolve_class_paths(callback)
--     local classpaths = {}

--     local function resolve_all_class_paths(class_iter)
--         local class_info = class_iter.next()

--         if not class_info then return callback(classpaths) end

--         M.resolve_class_path(
--             class_info.mainClass, class_info.projectName, function(class_path)
--                 table.insert(
--                     classpaths,
--                     { class_info = class_info, class_path = class_path })

--                 resolve_all_class_paths(class_iter)
--             end)
--     end

--     M.resolve_main_classes(
--         function(main_class_info)
--             local index = 1

--             local main_class_iter = {
--                 next = function()
--                     local temp_index = index
--                     index = index + 1
--                     return main_class_info[temp_index]
--                 end,
--             }

--             resolve_all_class_paths(main_class_iter)
--         end)
-- end

-- --[[
-- -- Returns dap java debug configuration
-- --
-- -- @Param callback {function(config: Map)}
-- --]]
-- function M.get_dap_config(callback)
--     M.resolve_class_paths(
--         function(class_paths_info)
--             local conf = {}

--             for index, classpath_info in ipairs(class_paths_info) do
--                 local main_class = classpath_info.class_info.mainClass
--                 local project_name = classpath_info.class_info.projectName
--                 local class_paths = classpath_info.class_path

--                 table.insert(
--                     conf, {
--                         name = string.format(
--                             '(%d) Launch -> %s -> %s', index, project_name,
--                             main_class),
--                         projectName = project_name,
--                         mainClass = main_class,
--                         classPaths = vim.tbl_flatten(class_paths),
--                         modulePaths = {},
--                         request = 'launch',
--                         type = 'java',
--                         javaExec = '/usr/bin/java',
--                     })
--             end

--             callback(conf)
--         end)
-- end

-- local on_attach = function(client, bufnr)
--     if client.name == 'jdtls' then
--       print("Configuring DAP for jdtls")
--         M.get_dap_config(
--             function(conf)
--               print("dap config ready")
--                 dap.configurations.java = conf
--                 print('Debugger is ready')
--             end)
--     end
-- end

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local home = os.getenv "HOME"
  local opts = {}
  
  if server.name == "jdtls" then
    local bundles = {
        vim.fn.glob(home .. "/.config/lvim/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
    };
    vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.config/lvim/java/vscode-java-test/server/*.jar"), "\n"))

    opts["init_options"] = {
      bundles = bundles
    }

    server:setup(opts)
  end
end)

-- dap.adapters.java = function(callback)
--     M.start_debug_session(
--         function(port)
--             callback({ type = 'server', host = '127.0.0.1', port = port })
--         end)
-- end
