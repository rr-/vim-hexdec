# vim-hexdec

This vim plugin lets you convert hexadecimal numbers to decimal counterparts
and vice versa by exposing following functions:

- `:Hex2dec`
- `:Dec2hex`

The functions work for visual selection, block selection, line ranges and the
whole buffer. You can also convert the numbers without changing the file by
passing additional argument as in `:Hex2dec 0xdeadbeef`. Conversion should work
for arbitrary integers.

The plugin doesn't define any bindings and leaves the choice to the user.

Based on:

- http://vim.wikia.com/wiki/Convert_between_hex_and_decimal
- http://stackoverflow.com/questions/857070/
