local M = {}

local VAULT = vim.fn.expand '~/vault'

M.domains = {
  { code = '3000', name = 'Bitcoin', folder = '10-Concepts/3000-Bitcoin', topic = 'bitcoin' },
  { code = '3100', name = 'Cryptography', folder = '10-Concepts/3100-Cryptography', topic = 'cryptography' },
  { code = '3200', name = 'Networks', folder = '10-Concepts/3200-Networks', topic = 'networks' },
  { code = '3300', name = 'Distributed Systems', folder = '10-Concepts/3300-Distributed-Systems', topic = 'distributed-systems' },
  { code = '3400', name = 'Programming Language Theory', folder = '10-Concepts/3400-Programming Language Theory', topic = 'programming-languages' },
  { code = '3500', name = 'Functional Programming', folder = '10-Concepts/3500-Functional Programming', topic = 'functional-programming' },
  { code = '3600', name = 'Algorithms', folder = '10-Concepts/3600-Algorithms & Dynamic Programming', topic = 'algorithms' },
  { code = '3700', name = 'Mathematics', folder = '10-Concepts/3700-Mathematics', topic = 'mathematics' },
  { code = '3800', name = 'Data Analytics', folder = '10-Concepts/3800-Data Analytics', topic = 'data-analytics' },
  { code = '3900', name = 'Software Engineering', folder = '10-Concepts/3900-Experimental Software Engineering', topic = 'software-engineering' },
  { code = '4000', name = 'Embedded Systems', folder = '10-Concepts/4000-Embedded Systems', topic = 'embedded-systems' },
  { code = '4100', name = 'Career', folder = '10-Concepts/4100-Career', topic = 'career' },
  { code = '4200', name = 'Philosophy', folder = '10-Concepts/4200-Philosophy', topic = 'philosophy' },
  { code = '4300', name = 'Strategy & Psychology', folder = '10-Concepts/4300-Strategy & Psychology', topic = 'strategy' },
  { code = '4400', name = 'Warfare', folder = '10-Concepts/4400-Warfare', topic = 'warfare' },
  { code = '4500', name = 'Training', folder = '10-Concepts/4500-Training', topic = 'training' },
}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = 'Vault' })
end

local function slugify(value)
  local slug = vim.trim(value or ''):lower()
  slug = slug:gsub('[^%w%s%-]', ''):gsub('%s+', '-'):gsub('%-+', '-')
  return slug:gsub('^%-', ''):gsub('%-$', '')
end

M.slugify = slugify

local function all_stems()
  local stems = {}
  for _, path in ipairs(vim.fn.globpath(VAULT, '**/*.md', false, true)) do
    local stem = vim.fn.fnamemodify(path, ':t:r')
    stems[stem] = true
  end
  return stems
end

local function code_from_stem(stem)
  return tostring(stem or ''):match '^([0-9]+[a-z][a-z0-9]*)%-'
end

local function current_concept()
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' or not path:match '/10%-Concepts/' then
    notify('Abra uma nota em 10-Concepts para criar uma nota relacionada.', vim.log.levels.WARN)
    return nil
  end

  local stem = vim.fn.fnamemodify(path, ':t:r')
  local code = code_from_stem(stem)
  if not code then
    notify('A nota atual não possui um ID semântico reconhecível.', vim.log.levels.WARN)
    return nil
  end

  return {
    path = path,
    dir = vim.fn.fnamemodify(path, ':h'),
    code = code,
  }
end

local function next_sibling(code)
  local family, letter, suffix = code:match '^([0-9]+)([a-z])([0-9]*)$'
  if not family then
    return nil
  end

  local stems = all_stems()
  if suffix == '' then
    local max_letter = 0
    for stem in pairs(stems) do
      local candidate = stem:match('^' .. family .. '([a-z])%-')
      if candidate then
        max_letter = math.max(max_letter, string.byte(candidate) - string.byte 'a' + 1)
      end
    end
    return family .. string.char(string.byte 'a' + max_letter)
  end

  local max_number = 0
  for stem in pairs(stems) do
    local candidate = stem:match('^' .. family .. letter .. '([0-9]+)%-')
    if candidate then
      max_number = math.max(max_number, tonumber(candidate))
    end
  end
  return family .. letter .. (max_number + 1)
end

local function next_child(code)
  if code:match '[a-z]$' then
    return code .. '1'
  end
  return code .. 'a'
end

local function domain_for_code(code)
  local domain_code = code:sub(1, 4)
  for _, domain in ipairs(M.domains) do
    if domain.code == domain_code then
      return domain
    end
  end
end

local function next_family(domain)
  local max_family = 0
  for stem in pairs(all_stems()) do
    local suffix = stem:match('^' .. domain.code .. '([0-9]+)[a-z]%-')
    if suffix then
      max_family = math.max(max_family, tonumber(suffix))
    end
  end
  return domain.code .. (max_family + 1)
end

local function create_note(opts)
  local filename = opts.filename .. '.md'
  local target = vim.fs.joinpath(VAULT, opts.dir, filename)
  if vim.uv.fs_stat(target) then
    notify('A nota já existe: ' .. vim.fs.relpath(VAULT, target), vim.log.levels.WARN)
    return
  end

  local Note = require 'obsidian.note'
  local note = Note.create {
    id = opts.filename,
    title = opts.title,
    dir = opts.dir,
    verbatim = true,
    template = opts.template,
    aliases = { opts.title },
    tags = opts.tags or {},
  }
  note:write()
  note:open()
end

local function prompt_title(prompt, callback)
  vim.ui.input({ prompt = prompt }, function(title)
    title = title and vim.trim(title) or ''
    if title == '' then
      notify('Operação cancelada.', vim.log.levels.WARN)
      return
    end
    callback(title)
  end)
end

function M.capture()
  prompt_title('Título da captura: ', function(title)
    local filename = slugify(title)
    if filename == '' then
      notify('O título não produz um nome de arquivo válido.', vim.log.levels.ERROR)
      return
    end
    create_note {
      filename = filename,
      title = title,
      dir = '00-Inbox',
      template = 'Inbox.md',
      tags = { 'inbox' },
    }
  end)
end

function M.source()
  prompt_title('Título da fonte: ', function(title)
    local filename = slugify(title)
    if filename == '' then
      notify('O título não produz um nome de arquivo válido.', vim.log.levels.ERROR)
      return
    end
    create_note {
      filename = filename,
      title = title,
      dir = '20-Resources/Articles',
      template = 'Source.md',
      tags = { 'source' },
    }
  end)
end

function M.related()
  local current = current_concept()
  if not current then
    return
  end

  local code = next_sibling(current.code)
  if not code then
    notify('Não foi possível calcular o próximo irmão.', vim.log.levels.ERROR)
    return
  end

  prompt_title(code .. ' — título: ', function(title)
    local slug = slugify(title)
    if slug == '' then
      notify('O título não produz um nome de arquivo válido.', vim.log.levels.ERROR)
      return
    end
    create_note {
      filename = code .. '-' .. slug,
      title = title,
      dir = current.dir,
      template = 'Concept.md',
      tags = { 'concept' },
    }
  end)
end

function M.child()
  local current = current_concept()
  if not current then
    return
  end

  local code = next_child(current.code)
  prompt_title(code .. ' — título: ', function(title)
    local slug = slugify(title)
    if slug == '' then
      notify('O título não produz um nome de arquivo válido.', vim.log.levels.ERROR)
      return
    end
    create_note {
      filename = code .. '-' .. slug,
      title = title,
      dir = current.dir,
      template = 'Concept.md',
      tags = { 'concept' },
    }
  end)
end

function M.family()
  vim.ui.select(M.domains, {
    prompt = 'Domínio da nova família: ',
    format_item = function(domain)
      return domain.code .. ' — ' .. domain.name
    end,
  }, function(domain)
    if not domain then
      notify('Operação cancelada.', vim.log.levels.WARN)
      return
    end

    prompt_title(domain.code .. ' — nome da família: ', function(title)
      local slug = slugify(title)
      if slug == '' then
        notify('O título não produz um nome de arquivo válido.', vim.log.levels.ERROR)
        return
      end
      local family = next_family(domain)
      local code = family .. 'a'
      local dir = domain.folder .. '/' .. family .. '-' .. slug
      create_note {
        filename = code .. '-' .. slug,
        title = title,
        dir = dir,
        template = 'Concept.md',
        tags = { 'concept', domain.topic },
      }
    end)
  end)
end

local function note_kind(note)
  local template = tostring(note.template or '')
  local path = tostring(note.path or '')
  if template:match 'Concept%.md' or path:match '/10%-Concepts/' then
    return 'concept'
  elseif template:match 'Source%.md' or path:match '/20%-Resources/' then
    return 'source'
  elseif template:match 'Inbox%.md' or path:match '/00%-Inbox/' then
    return 'inbox'
  elseif path:match '/30%-Projects/' then
    return 'project'
  end
  return nil
end

function M.frontmatter(note)
  local metadata = vim.deepcopy(note.metadata or {})
  local kind = note_kind(note)
  local code = code_from_stem(note.id) or note.id
  local title = note.title or metadata.title or code

  metadata.id = code
  metadata.title = title
  metadata.aliases = note.aliases and #note.aliases > 0 and note.aliases or metadata.aliases or {}
  metadata.tags = note.tags and #note.tags > 0 and note.tags or metadata.tags or {}
  metadata.created = metadata.created or os.date '%Y-%m-%d'
  metadata.modified = os.date '%Y-%m-%d'

  if kind == 'concept' then
    local domain_code = tostring(note.path or ''):match '/10%-Concepts/(%d%d%d%d)-'
    local domain = domain_code and domain_for_code(domain_code) or nil
    metadata.type = 'concept'
    metadata.status = metadata.status or 'seed'
    if domain then
      metadata.primary_topic = metadata.primary_topic or domain.topic
      metadata.topics = metadata.topics or { domain.topic }
    end
  elseif kind == 'source' then
    metadata.type = 'source'
    metadata.source_type = metadata.source_type or 'article'
    metadata.topics = metadata.topics or {}
    metadata.concepts = metadata.concepts or {}
  elseif kind == 'inbox' then
    metadata.type = 'inbox'
    metadata.status = metadata.status or 'unprocessed'
    metadata.captured = metadata.captured or os.date '%Y-%m-%d'
    metadata.topics = metadata.topics or {}
  end

  return metadata
end

function M.setup()
  local commands = {
    VaultCapture = M.capture,
    VaultSource = M.source,
    VaultConceptRelated = M.related,
    VaultConceptChild = M.child,
    VaultConceptFamily = M.family,
  }

  for name, callback in pairs(commands) do
    vim.api.nvim_create_user_command(name, callback, { desc = 'Vault: ' .. name, force = true })
  end
end

return M
