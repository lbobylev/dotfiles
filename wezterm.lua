local wezterm = require 'wezterm'

return {
  font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Bold" }),
  --color_scheme = "Catppuccin Mocha",
  font_size = 14,
  initial_cols = 120,
  initial_rows = 30,
  audible_bell = "Disabled",
  hide_tab_bar_if_only_one_tab = true,
  --freetype_load_target = "Light",  -- Легкое сглаживание
  --use_kerning = true,              -- Включение кернинга для улучшения интервалов между буквами
  --harfbuzz_features = { "calt=1", "clig=1", "liga=1" },  -- Включение антиалиасинга и лигатур
  -- Привязки клавиш для Option + стрелки
  keys = {
    -- Option + Left Arrow (перемещение на одно слово влево)
    {key="LeftArrow", mods="ALT", action=wezterm.action{SendString="\x1bb"}},

    -- Option + Right Arrow (перемещение на одно слово вправо)
    {key="RightArrow", mods="ALT", action=wezterm.action{SendString="\x1bf"}},
  },
  window_close_confirmation = 'NeverPrompt'
}
