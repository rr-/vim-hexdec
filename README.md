# vim-hexdec

A small number base conversion script for Neovim.

## Description

This vim plugin lets you convert hexadecimal numbers to decimal counterparts
and vice versa by exposing following functions:

- `:Hex2Dec`
- `:Dec2Hex`
- `:Dec2Hexl`
- `:ToggleHexDec`

The functions work for visual selection, block selection, line ranges and the
whole buffer. Conversion should work for arbitrary positive integers.

## Bindings

The plugin doesn't define any bindings and leaves the choice to the user.
Here's a demonstration how to bind the commands in the `.vimrc` file:

    nnoremap gbh :Dec2Hex<CR>
    nnoremap gbl :Dec2Hexl<CR>
    nnoremap gbd :Hex2Dec<CR>
    nnoremap gbt :ToggleHexDec<CR>

## Installation

Use your favorite plugin manager. For example, using
[`vim-plug`](https://github.com/junegunn/vim-plug):

    Plug 'rr-/vim-hexdec'

## Related work

Based on:

- http://vim.wikia.com/wiki/Convert_between_hex_and_decimal
- http://stackoverflow.com/questions/857070/
