"decimal ↔ hexadecimal conversions

let s:HEX_CHARS = [
  \ '0', '1', '2', '3', '4', '5', '6', '7',
  \ '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']

function! s:AddDecValue(hex_array, value, source_base, target_base)
  let carryover = a:value
  let tmp = 0
  let i = len(a:hex_array) - 1
  while (i >= 0)
    let tmp = (index(s:HEX_CHARS, a:hex_array[i]) * a:source_base) + carryover
    let a:hex_array[i] = s:HEX_CHARS[tmp % a:target_base]
    let carryover = tmp / a:target_base
    let i = i -1
  endwhile
endfunction

function! s:ConvertBase(string, source_base, target_base)
  let input = split(toupper(a:string), '.\zs')
  let output = repeat(['0'], len(input) * 2)
  for digit in input
    let idx = index(s:HEX_CHARS, digit)
    if idx == -1
      echo 'Error converting base - unknown digit: ' . digit
      return ''
    end
    call s:AddDecValue(output, idx, a:source_base, a:target_base)
  endfor
  while len(output) > 1 && output[0] == '0'
    let output = output[1:]
  endwhile
  return join(output, '')
endfunction

command! -nargs=? -range Dec2hex call s:Dec2hex(<line1>, <line2>, '<args>')
function! s:Dec2hex(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V\<\d\+\>/\=printf("0x%s",s:ConvertBase(submatch(0), 10, 16))/g'
    else
      let cmd = 's/\<\d\+\>/\=printf("0x%s",s:ConvertBase(submatch(0), 10, 16))/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No decimal number found'
    endtry
  else
    echo '0x' . s:ConvertBase(a:arg, 10, 16)
  endif
endfunction

command! -nargs=? -range Hex2dec call s:Hex2dec(<line1>, <line2>, '<args>')
function! s:Hex2dec(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V0x\(\x\+\)/\=printf("%s",s:ConvertBase(submatch(1), 16, 10))/g'
    else
      let cmd = 's/0x\(\x\+\)/\=printf("%s",s:ConvertBase(submatch(1), 16, 10))/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No hex number starting "0x" found'
    endtry
  else
    let tmp = substitute(a:arg, '^0x', '', 'i')
    echo s:ConvertBase(tmp, 16, 10)
  endif
endfunction
