return {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if string.match(fname, "api%-e2e") then
      on_dir('/home/alai/freelancer-dev/fl-gaf/api-e2e')
    else
      on_dir('/home/alai/freelancer-dev/fl-gaf/webapp')
    end
  end,
}
