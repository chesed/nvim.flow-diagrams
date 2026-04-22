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
    local buflines = vim.api.nvim_buf_linecount(bufnr)

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
    local buplnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local start_line = cursor[1]

    local start_idx, end_idx = get_phrase_range(buplnr, start_line)

    for i = start_idx, end_idx do
        local line = vim.api.nvim_buf_get_lines(buplnr, i - 1, i, false)[1]
        if line then
            -- Remove up to 4 leading spaces
            local new_line = line:gsub("^%s%s%s%s", "")
            vim.api.nvim_buf_set_lines(buplnr, i - 1, i, false, { new_line })
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
    local buflines = vim.api.nvim_buf_linecount(bufnr)
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
    -- In Normal mode, we want to: enter insert, enter, escape.
    -- We can simulate this with a command.
    vim.cmd("normal! i<CR><Esc>")
end

-- NEW: Jump to char immediately following next punctuation
function M.jump_after_punctuation()
    -- Pattern for punctuation: [.,!?;:]
    -- We use vim.fn.search to find the next occurrence
    local pattern = "[.,!?;:]"
    local pos = vim.fn.search(pattern, "W") -- 'W' searches forward
    if pos ~= 0 then
        -- Move cursor to the character AFTER the found position
        -- Note: search returns the start of the match.
        -- We need to move to the next character.
        local line = vim.api.nvim_win_get_cursor(0)[1]
        local col = vim.api.nvim_win_get_cursor(0)[2]
        -- We need to find where that char is in the buffer.
        -- A simpler way: use the search result to find the char and then move.
        -- Actually, vim.fn.search returns the position.
        -- Let's use the more robust way: find the position and then move.
        -- We'll use the 'W' flag which finds the next.
        -- We want the character AFTER.
        -- If we just use 'w' or similar, it might be easier.
        -- Let's use 'f' or 't' logic via vim.fn.search.
        -- We'll use the search result to find the column.
        -- Wait, search returns the line/col in the buffer.
        -- We can use the return value to set cursor.
        -- But search() returns the position of the match.
        -- Let's try a different approach:
        -- Use vim.fn.search with pattern and then move the cursor to the character after.
        -- The return value of search is the position.
        -- We'll just use the 'f' command approach if we want to be simple.
        -- But we want to find the NEXT punctuation mark.
        -- Let's use vim.fn.search and then manually move.
        -- We need to find the line and column.
        -- Since search() is called, the cursor is already there.
        -- We just need to move one character forward.
        vim.cmd("normal! l")
    end
end

-- NEW: Jump to char immediately preceding next punctuation (searching backward)
function M.jump_before_punctuation()
    local pattern = "[.,!?;:]"
    -- We use '?' for backward search
    local pos = vim.fn.search(pattern, "W") -- wait, '?' is backward.
    -- Let's use the actual vim.fn.search logic.
    -- 'W' is forward.
    -- We'll use '?' flag.
    -- We'll use the search result and then move the cursor backward.
    -- However, to find the PREVIOUS punctuation, we use '?'
    -- Let's check if search(pattern, 'W') is correct for forward.
    -- Actually, the second argument is 'flags'. 'W' is NOT a flag for search.
    -- The flags are: 'b' (backward), 'W' (wrap), etc.
    -- Let's use 'b' for backward search.
    -- We'll use the search result and move backward.
    -- Actually, we'll use the pattern '[.,!?;:]' and the 'b' flag.
    -- If we find it, we move cursor back one.
    -- Let's try:
    -- vim.fn.search(pattern, 'b')
    -- Let's just use the command approach:
    -- :normal! F, (where , is the punct)
    -- But we don't know which punct.
    -- So we'll use:
    -- vim.cmd("normal! F[.,!?;:]") -- This doesn't work in normal mode easily.
    -- Let's use:
    -- vim.api.nvim_command("normal! f,") -- but we don't know the char.
    -- Let's use:
    -- vim.api.nvim_command("normal! T,")
    -- We'll use a regex search.
    local pattern = "[.,!?;:]"
    local found = vim.fn.search(pattern, "") -- forward
    if found ~= 0 then
        -- We found it. The cursor is now AT the char.
        -- We want the char AFTER.
        vim.cmd("normal! l")
    end
end

-- Wait, let's refine the jump functions.
-- The user wants:
-- 1. jump to char AFTER next punctuation.
-- 2. jump to char BEFORE next punctuation (meaning the one we just passed? No, "next punctuation" usually implies searching forward).
-- If I'm at 'A' in "A, B", the next punct is ','. The char after is ' '.
-- If I'm at 'B' in "A, B", the PREVIOUS punct is ','. The char before is ' '.
-- Let's assume they mean:
-- 1. Find next punct, move to char after.
-- 2. Find previous punct, move to char before.

-- Let's rewrite these two functions cleanly.

function M.jump_after_next_punct()
    local pattern = "[.,!?;:]"
    -- Search forward
    local found = vim.fn.search(pattern, "")
    if found ~= 0 then
        -- Move one char forward from the match
        vim.cmd("normal! l")
    end
end

function M.jump_before_prev_punct()
    local pattern = "[.,!?;:]"
    -- Search backward
    local found = vim.fn.search(pattern, "b")
    if found ~= 0 then
        -- Move one char backward from the match
        vim.cmd("normal! h")
    end
end

return M
