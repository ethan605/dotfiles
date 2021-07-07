-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/ethanify/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/ethanify/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/ethanify/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/ethanify/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/ethanify/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["auto-pairs"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/auto-pairs"
  },
  ["blamer.nvim"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/blamer.nvim"
  },
  ["fugitive-gitlab.vim"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/fugitive-gitlab.vim"
  },
  fzf = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  indentLine = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/indentLine"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim"
  },
  nerdTree = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/nerdTree"
  },
  nerdcommenter = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/nerdcommenter"
  },
  ["nerdtree-git-plugin"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/nerdtree-git-plugin"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["vim-airline"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-airline"
  },
  ["vim-airline-themes"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-airline-themes"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-devicons"
  },
  ["vim-easymotion"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-easymotion"
  },
  ["vim-fubitive"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-fubitive"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-go"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-go"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-rhubarb"
  },
  ["vim-rooter"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-rooter"
  },
  ["vim-snazzy"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-snazzy"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-visual-multi"] = {
    loaded = true,
    path = "/home/ethanify/.local/share/nvim/site/pack/packer/start/vim-visual-multi"
  }
}

time([[Defining packer_plugins]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: ".v:exception | echom "Please check your config for correctness" | echohl None')
end
