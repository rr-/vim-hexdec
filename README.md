# vim-hexdec

A small number base conversion script for Vim.

## Description

This vim plugin lets you convert hexadecimal numbers to decimal counterparts
and vice versa by exposing following functions:

- `:Hex2dec`
- `:Dec2hex`

The functions work for visual selection, block selection, line ranges and the
whole buffer. You can also convert the numbers without changing the file by
passing additional argument as in `:Hex2dec 0xdeadbeef`. Conversion should work
for arbitrary positive integers.

## Demo

![GIF animation](https://cloud.githubusercontent.com/assets/1045476/15802614/490d8b4e-2ab8-11e6-9129-f234398967c3.gif)

## Bindings

The plugin doesn't define any bindings and leaves the choice to the user.
Here's a demonstration how to bind the commands in the `.vimrc` file:

    nnoremap gbh :Dec2hex<CR>
    nnoremap gbd :Hex2dec<CR>

## Installation

Use your favorite plugin manager. For example, using
[`vim-plug`](https://github.com/junegunn/vim-plug):

    Plug 'rr-/vim-hexdec'

## Related work

Based on:

- http://vim.wikia.com/wiki/Convert_between_hex_and_decimal
- http://stackoverflow.com/questions/857070/
