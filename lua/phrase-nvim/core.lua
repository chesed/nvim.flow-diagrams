local M = {}

-- Helper: Get the indentation level of a line
local function get_indent(bufnr, line_idx)
    local line = vim.api.nvim_buf_get_lines(bufnr, line_idx - 1, line_idx, false)[1]
    if not line then return 0 end
    return #line:match("^%s*")
end

-- Helper: Identify the range of the current phrase block (start_line to end_line)
local function get_phrase_range(bufnr, start_line)
    local start_indent = get_indent(bufnr, start_line)
    local end_line = start_line
    local buflines = vim.api.nvim_buf_line_count(bufnr)

    for i = start_line + 1, buflines do
        local indent = get_indent(bufnr, i)
        if indent <= start_indent then
            break
        end
        end_line = i
    end
    return start_line, end_line
end

-- Core Function: Indent a phrase block
function M.indent_phrase()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local start_line = cursor[1]

    local start_idx, end_idx = get_phrase_range(bufnr, start_line)

    for i = start_idx, end_idx do
        local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
        if line then
            vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { "    " .. line })
        end
    end
end

-- Core Function: Outdent a phrase block
function M.outdent_phrase()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local start_line = cursor[1]

    local start_idx, end_idx = get_phrase_range(bufnr, start_line)

    for i = start_idx, end_idx do
        local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
        if line then
            -- Remove up to 4 leading spaces
            local new_line = line:gsub("^%s%s%s%s", "")
            vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { new_line })
        end
    end
end

-- Core Function: Move phrase block up
function M.move_phrase_up()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local start_line = cursor[1]

    local start_idx, end_idx = get_phrase_range(bufnr, start_line)
    if start_idx <= 1 then return end

    local lines = vim.api.nvim_buf_get_lines(bufnr, start_idx - 1, end_idx + 1, false)
    -- Shift lines up by 1
    vim.api.nvim_buf_set_lines(bufnr, start_idx - 1, end_idx, false, lines)
    -- Clear the old position
    vim.api.nvim_buf_set_lines(bufnr, end_idx, end_idx + 1, false, { "" })

    -- Restore cursor position
    vim.api.nvim_win_set_cursor(0, { start_line - 1, 0 })
end

-- Core Function: Move phrase block down
function M.move_phrase_down()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local start_line = cursor[1]

    local start_idx, end_idx = get_phrase_range(bufnr, start_line)
    local buflines = vim.api.nvim_buf_line_count(bufnr)
    if end_idx >= buflines then return end

    local lines = vim.api.nvim_buf_get_lines(bufnr, start_idx - 1, end_idx + 1, false)
    -- Shift lines down by 1
    vim.api.nvim_buf_set_lines(bufnr, start_idx, end_idx + 2, false, lines)
    -- Clear the old position
    vim.api.nvim_buf_set_lines(bufnr, start_idx - 1, start_idx, false, { "" })

    -- Restore cursor position
    vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
end

-- NEW: Break line at cursor and return to Normal mode
function M.break_line()
    vim.cmd("normal! i<CR><Esc>")
end

-- NEW: Jump to char immediately following next punctuation
function M.jump_after_next_punct()
    local pattern = "[.,!?;:]"
    local found = vim.fn.search(pattern, "")
    if found ~= 0 then
        vim.cmd("normal! l")
    end
end

-- NEW: Jump to char immediately preceding next punctuation (searching backward)
function M.jump_before_prev_punct()
    local pattern = "[.,!?;:]"
    local found = vim.fn.search(pattern, "b")
    if found ~= 0 then
        vim.cmd("normal! h")
    end
end

-- NEW: Clean text (remove numbers and split by punctuation)
function M.clean_and_split()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Join everything into one giant string to process globally
    local text = table.concat(lines, " ")

    -- 1. Remove all digits (verse numbers)
    text = text:gsub("%d+", "")

    -- 2. Split by punctuation followed by space/newline
    -- We use a capture to keep the punctuation mark itself
    -- We look for punctuation followed by optional whitespace
    text = text:gsub("([.,!?;:])%s*", "%1\n")

    -- 3. Clean up extra whitespace/empty lines resulting from the split
    local new_lines = {}
    for line in text:gmatch("[^\r\n]+") do
        -- Trim leading/trailing whitespace from each new line
        local trimmed = line:gsub("^%s*", ""):gsub("%s*$", "")
        if trimmed ~= "" then
            table.insert(new_lines, trimmed)
        end
    end

    -- Update the buffer
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
end

return M
