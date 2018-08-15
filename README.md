# About


yangmu373's vimrc for [Vim](http://www.vim.org) [MacVim](https://github.com/macvim-dev/macvim) and [GVim](http://www.vim.org)

Supports language PHP JavaScript CSS HTML Node.js React Go and Rust

Requires [Git] 1.7+ and [Vim] 7.3+

## Quick Start

1. Set up vimrc:

   `$ git clone https://github.com/yangmu373/vimrc`

   `$ cd vimrc`

   *Your own `~/.vimrc` will be covered*

   `$ cp vimrc ~/.vimrc`

2. Set up [Vundle](https://github.com/VundleVim/Vundle.vim):

   `$ git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim`

3. Install Plugins:

   Launch `vim` and run `:PluginInstall`

4. Install all the necessary binaries for vim-go:

   Launch `vim` and run `:GoInstallBinaries`

5. Make JSX highlight better:

   `$ mkdir -p ~/.vim/after/syntax/javascript`

   `$ cp ~/.vim/bundle/vim-jsx/after/syntax/jsx.vim ~/.vim/after/syntax/javascript/jsx.vim`

   `$ mkdir -p ~/.vim/after/indent/javascript`

   `$ cp ~/.vim/bundle/vim-jsx/after/indent/jsx.vim ~/.vim/after/indent/javascript/jsx.vim`
