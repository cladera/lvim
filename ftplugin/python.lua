local ok, dap_install = pcall(require, 'dap_install')

if ok then
  dap_install.config('python', {})
end

