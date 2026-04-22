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

-- Keybindings
vim.keymap.set("n", "<leader>pi", "<cmd>PhraseIndent<CR>", { desc = "Phrase Indent" })
vim.keymap.set("n", "<leader>po", "<cmd>PhraseOutdent<CR>", { desc = "Phrase Outdent" })
vim.keymap.set("n", "<leader>pu", "<cmd>PhraseMoveUp<CR>", { desc = "Phrase Move Up" })
vim.keymap.set("n", "<leader>pd", "<cmd>PhraseMoveDown<CR>", { desc = "Phrase Move Down" })
vim.keymap.set("n", "<leader>pc", "<cmd>PhraseConnector<CR>", { desc = "Phrase Connector" })
