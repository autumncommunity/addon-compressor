local lib = {}
lib.author = "smokingplaya"
lib.data_folder = "compressor"
lib.debug_print = false

// оптимайз чтобы в функции лишних проверок не было
local dev_print
if lib.debug_print then
    function dev_print(msg)
        print(msg)
    end
else
    function dev_print() end
end

-- из t2 в t1
local function add_in_table(t1, t2)
    for _, v in ipairs(t2) do
        t1[#t1+1] = v
    end
end


local function add_prefix_to_table_strings(prefix, t)
    local t1 = {}

    for i, v in ipairs(t) do
        t1[i] = prefix .. v
    end

    return t1
end

local find_files

function find_files(folder)
    local tab = {}
    local path = folder
    local files, folders = file.Find(path .. "/*", "GAME")

    add_in_table(tab, add_prefix_to_table_strings(path .. "/", files))

    dev_print("Current folder >> " .. path)

    for _, folder_name in ipairs(folders) do
        local p = path .. "/" .. folder_name
        local files = find_files(p)

        dev_print(">> " .. p)

        add_in_table(tab, files)
    end

    return tab
end

local function check_data_folder()
    if not file.IsDir(lib.data_folder, "DATA") then
        file.CreateDir(lib.data_folder)
    end
end

function lib:Compress(folder)
    dev_print("\nStarting compress \"" .. folder .. "\" folder\n")

    local time = SysTime()

    local files = find_files("addons/" .. folder .. "/lua")

    dev_print("")

    -- compress file

    local compressed = "local this_compressed = true"
    for _, file_name in ipairs(files) do
        compressed = compressed .. "\n-- " .. file_name .. "\ndo\n" .. file.Read(file_name, "GAME") .. "\nend"
    end

    -- save file

    local compressed_file_name = "compressed_" .. folder .. ".txt"
    local compressed_file_name_full_path = lib.data_folder .. "/" .. compressed_file_name

    check_data_folder()

    if file.Exists(compressed_file_name_full_path, "DATA") then
        file.Delete(compressed_file_name_full_path, "DATA")
    end

    file.Append(compressed_file_name_full_path, compressed)

    dev_print("\nCompressed file saved as " .. compressed_file_name .. " in data/" .. lib.data_folder .. " \n")

    dev_print("\n\"" ..folder .. "\" folder compressed " .. #files .. " files for " .. (SysTime()-time) .. "s")
end

local _, addon_list = file.Find("addons/*", "GAME")

concommand.Add("compress_lua", function(pl, _, args)
    if not game.SinglePlayer() and not pl:IsSuperAdmin() or pl ~= NULL then print("You haven't rights for that!") return end
    if not args[1] then print("Please enter name of folder that you wanna compress!") return end

    lib:Compress(args[1])
end, function(_, stringargs)
    local tab = {}

    for _, addon in ipairs(addon_list) do
        if addon:find(stringargs:Trim()) then
            tab[#tab+1] = addon
        end
    end

    return tab
end)