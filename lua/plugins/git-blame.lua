return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = " <author> • <summary> • <date> • <<sha>>",
      virtual_text_column = 1,
    },
  },
}
