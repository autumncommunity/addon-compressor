# Compressor
A small utility that allows you to compress an entire addon folder into a single file.

[Do you have any questions? Ask them in our discord!](https://discord.gg/HspPfVkHGh)

<h3>⚠️ Keep in mind that the server and client files will be in the same file, which means that if your server gets hacked, people will get the server source code as well. So you may want to use a obsufication just in case.</h3>

## How to use
Suppose you have an addon placed in the **addons/megagianttakis** folder.

It contains quite a lot of lua files and you don't want your client to download them all separately.

Then install **compressor** in the addons folder, **go to the game and open the console.**

You must have **superadmin** rights to run the command.

Type the command **compress_lua** in the console and after it the name of the folder in **addons/** that you want to compress into one file.

After that go to **garrysmod/data/compressor** folder and you will find the file **compressed_foldername.txt**, rename it to **compressed_foldername.lua** and you can use it!

## For developers:
When an addon has been compressed, the variable **this_compressed** is shoved into the beginning of its file to indicate that the file's environment has been compressed into a single file.

So if your addon calls **include/AddCSLuaFile** functions specifying files from the addon directory, for the time of addon development, stick the **include/AddCSLuaFile** functions in the if construct that will check if the current file is compressed.

Like this:

```lua
-- after
AddCSLuaFile("myaddon/sh_config.lua")
include("myaddon/sh_config.lua")

-- before
if this_compressed then
  AddCSLuaFile("myaddon/sh_config.lua")
  include("myaddon/sh_config.lua")
end
```
