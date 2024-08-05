local PATTERN_HEX = "0x[0-9a-fA-F]+"
local PATTERN_DEC = "%f[%w]%d+%f[%W]"

local function process_selection(opts, process_text_cb)
    -- Get the current buffer
    local bufnr = vim.api.nvim_get_current_buf()

    local start_line, end_line

    if opts.range == 0 then
        -- Cursor mode: get the line at the cursor
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        start_line = current_line - 1
        end_line = current_line
    else
        -- Range mode; get the provided line range
        start_line = opts.line1 - 1
        end_line = opts.line2
    end

    -- Get the content of the lines in the specified range
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

    -- Detect the visual mode if applicable
    local mode = vim.fn.visualmode()

    if mode == "V" then
        -- Line-wise visual mode (V)
        for i, line in ipairs(lines) do
            lines[i] = process_text_cb(line)
        end
    elseif mode == "v" then
        -- Character-wise mode (v)
        local start_col = vim.fn.virtcol("'<") - 1
        local end_col = vim.fn.virtcol("'>")

        for i, line in ipairs(lines) do
            if i == 1 then
                real_start_col = start_col
            else
                real_start_col = 0
            end
            if i == #lines then
                real_end_col = end_col
            else
                real_end_col = -1
            end
            local prefix = line:sub(1, real_start_col)
            local block = line:sub(real_start_col + 1, real_end_col)
            local suffix = line:sub(real_end_col + 1)
            block = process_text_cb(block)
            lines[i] = prefix .. block .. suffix
        end
    elseif mode == "\22" then
        -- Visual block mode (CTRL-V)
        local start_col = vim.fn.virtcol("'<") - 1
        local end_col = vim.fn.virtcol("'>")

        for i, line in ipairs(lines) do
            local prefix = line:sub(1, start_col)
            local block = line:sub(start_col + 1, end_col)
            local suffix = line:sub(end_col + 1)
            block = process_text_cb(block)
            lines[i] = prefix .. block .. suffix
        end
    end

    -- Set the modified lines back to the buffer
    vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, lines)
end

local function hex_to_dec(text)
    text =
        text:gsub(
        PATTERN_HEX,
        function(hex)
            return tostring(tonumber(hex))
        end
    )
    return text
end

local function dec_to_hex(text)
    text =
        text:gsub(
        PATTERN_DEC,
        function(num)
            return string.format("0x%X", tonumber(num))
        end
    )
    return text
end

local function dec_to_hex_lowercase(text)
    text =
        text:gsub(
        "%f[%w]%d+%f[%W]",
        function(num)
            return string.format("0x%x", tonumber(num))
        end
    )
    return text
end

local function toggle_dec_hex(text)
    text =
        text:gsub(
        PATTERN_HEX,
        function(part)
            return "OLD" .. part
        end
    )
    text = dec_to_hex(text)
    text =
        text:gsub(
        "OLD" .. PATTERN_HEX,
        function(part)
            return tostring(tonumber(part:sub(4, -1)))
        end
    )
    return text
end

local function cmd_hex_to_dec(opts)
    process_selection(opts, hex_to_dec)
end

local function cmd_dec_to_hex(opts)
    process_selection(opts, dec_to_hex)
end

local function cmd_dec_to_hex_lowercase(opts)
    process_selection(opts, dec_to_hex_lowercase)
end

local function cmd_toggle_dec_hex(opts)
    process_selection(opts, toggle_dec_hex)
end

vim.api.nvim_create_user_command("Hex2Dec", cmd_hex_to_dec, {range = true})
vim.api.nvim_create_user_command("Dec2Hex", cmd_dec_to_hex, {range = true})
vim.api.nvim_create_user_command("Dec2Hexl", cmd_dec_to_hex_lowercase, {range = true})
vim.api.nvim_create_user_command("ToggleHexDec", cmd_toggle_dec_hex, {range = true})
