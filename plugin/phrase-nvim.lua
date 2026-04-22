local core = require("phrase-nvim.core")
local ui = require("phrase-nvim.ui")

-- Commands
vim.api.nvim_create_user_command("PhraseIndent", function()
    core.indent_phrase()
end, {})

vim.api.nvim_create_user_command("PhraseOutdent", function()
    core.outdent_phrase()
end, {})

vim.api.nvim_create_user_command("PhraseMoveUp", function()
    core.move_phrase_up()
end, {})

vim.api.nvim_create_user_command("PhraseMoveDown", function()
    core.move_phrase_down()
end, {})

vim.api.nvim_create_user_command("PhraseConnector", function()
    local connectors = ui.get_connectors()
    vim.ui.select(connectors, {
        prompt = "Select a connector: ",
    }, function(choice, index)
        if choice then
            ui.insert_connector_by_choice(choice)
        end
    end)
end, {})

vim.api.nvim_create_user_command("PhraseBreak", function()
    core.break_line()
end, {})

vim.api.nvim_create_user_command("PhraseNextPunct", function()
    core.jump_after_next_punct()
end, {})

vim.api.nvim_create_user_command("PhrasePrevPunct", function()
    core.jump_before_prev_punct()
end, {})

vim.api.nvim_create_user_command("PhraseClean", function()
    core.clean_and_split()
end, {})

-- Keybindings
vim.keymap.set("n", "<leader>pi", "<cmd>PhraseIndent<CR>", { desc = "Phrase Indent" })
vim.keymap.set("n", "<leader>po", "<cmd>PhraseOutdent<CR>", { desc = "Phrase Outdent" })
vim.keymap.set("n", "<leader>pu", "<cmd>PhraseMoveUp<CR>", { desc = "Phrase Move Up" })
vim.keymap.set("n", "<leader>pd", "<cmd>PhraseMoveDown<CR>", { desc = "Phrase Move Down" })
vim.keymap.set("n", "<leader>pc", "<cmd>PhraseConnector<CR>", { desc = "Phrase Connector" })

vim.keymap.set("n", "<leader>ps", "<cmd>PhraseBreak<CR>", { desc = "Phrase Split (Break Line)" })
vim.keymap.set("n", "<leader>pf", "<cmd>PhraseNextPunct<CR>", { desc = "Phrase Next Punctuation" })
vim.keymap.set("n", "<leader>pb", "<cmd>PhrasePrevPunct<CR>", { desc = "Phrase Previous Punctuation" })

vim.keymap.set("n", "<leader>pclean", "<cmd>PhraseClean<CR>", { desc = "Phrase Clean (Remove Numbers & Split)" })
