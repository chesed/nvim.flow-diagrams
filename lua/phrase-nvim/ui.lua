local M = {}

local connectors = {
    "->",
    "[because]",
    "[although]",
    "[therefore]",
    "[but]",
    "[and]",
    "[if]",
    "[since]",
    "[while]",
    "[unless]"
}

function M.insert_connector_by_choice(choice)
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1]

    local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
    if not line then return end

    local new_line = choice .. " " .. line

    vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, { new_line })
end

function M.get_connectors()
    return connectors
end

return M
