# phrase-nvim

`phrase-nvim` is a Neovim plugin designed for **thought-flow diagramming** (also known as "phrasing"). It is an exegetical tool built to help readers trace the logical structure and argument of a text—such as the Bible—by manipulating text hierarchy through indentation and structural markers.

Instead of drawing abstract graphs, `phrase-nvim` treats the text itself as the diagram, using indentation to represent subordination and logical connectors to represent relationships.

## ✨ Features

- **Phrase-Aware Indentation**: Indent or outdent entire blocks of subordinate text (clauses/phrases) at once.
- **Structural Movement**: Move entire argument blocks up or down the buffer while preserving their internal hierarchy.
- **Logical Connectors**: Quickly insert semantic markers (e.g., `[because]`, `[although]`, `->`) at the start of lines to clarify relationships.

## 🚀 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  "YOUR_GITHUB_USERNAME/phrase-nvim",
}
```

*(Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username.)*

## 🛠 Usage

### Commands

The following commands are available in Neovimit:

| Command | Description |
| :--- | :--- |
| `:PhraseIndent` | Indents the current line and all subsequent lines that are more deeply indented. |
| `:PhraseOutdent` | Outdents the current phrase block. |
| `:PhraseMoveUp` | Moves the current phrase block up one line. |
| `:PhraseMoveDown` | Moves the current phrase block down one line. |
| `:PhraseConnector` | Opens a menu to select and insert a logical connector at the start of the current line. |

### Keybindings

The plugin comes with default keybindings using the `<leader>p` prefix:

| Keybinding | Command | Description |
| :--- | :--- | :--- |
| `<leader>pi` | `:PhraseIndent` | **P**hrase **I**ndent |
| `<leader>po` | `:PhraseOutdent` | **P**hrase **O**utdent |
| `<leader>pu` | `:PhraseMoveUp` | **P**hrase **U**p |
| `<leader>pd` | `:PhraseMoveDown` | **P**hrase **D**own |
| `<leader>pc` | `:PhraseConnector` | **P**hrase **C**onnector |

## 📖 Concept

The goal of "phrasing" is to make the flow of an argument visible through the physical layout of the text. By indenting a clause, you visually signal that it is subordinate to the preceding clause. By adding a connector like `[therefore]`, you explicitly label the logical relationship.

---
*Built for Neovim and lovers of structural exegesis.*
