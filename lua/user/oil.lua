local oil_ok, oil = pcall(require, "oil")

if not oil_ok then
  return
end

oil.setup()
