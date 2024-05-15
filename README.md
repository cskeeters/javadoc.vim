**NOTE: neovim users may want to use [javadoc.nvim](https://github.com/cskeeters/javadoc.nvim).**

# javadoc.vim

javadoc.vim is a lightweight plugin for vim.  It allows a user to open a browser to the javadoc for a class which the mouse is over (inspired by eclipse).

This plugin searches `g:javadoc_path` for a file with the same name as the word the cursor is over.  This plugin is package agnostic, so if it finds two classes with the same name, it will just open both.  It depends on find, sed, pidof, basename, and an external browser - which is configurable.

If there are two matches, there is some delay in opening the second match if the browser was not running when the first match was passed to the browser.  Firefox complained without the delay.

## Installation

See Vundle or Pathogen

## Usage

![Screencast](https://raw.githubusercontent.com/cskeeters/i/master/javadoc.gif)

See the [vim help](doc/javadoc.txt)
