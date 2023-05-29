# Lnunarvim Configuration

## Install 

Make sure you have installed [lunarvim](https://www.lunarvim.org/01-installing.html).

### Backup default configuration

Copy default lvim configuration to a save location in case you want to restore it.

```shell
cp ~/.config/lvim/ ~/.config/lvim.default/
```

### Clone this repo

Clone this repo to lvim's configuration path.

```shell
git clone https://github.com/cladera/lvim.git ~/.config/lvim
```

## `js-debug-adapter` workaround

1. Clone `vscode-js-debug`

```sh
git clone https://github.com/microsoft/vscode-js-debug.git ~/.local/share/lvim/mason/packages/js-debug-adapter 
```

2. Build adapter

```sh
cd ~/.local/share/lvim/mason/packages/js-debug-adapter/
npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out
```
