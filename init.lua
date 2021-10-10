local modstorage = core.get_mod_storage()

local last_wear
local last_tool

if modstorage:get_string("warn") == "" then
  modstorage:set_string("warn", "true")
end

if modstorage:get_string("warn_lvl") == "" then
  modstorage:set_string("warn_lvl", "90")
end

if modstorage:get_string("warn") == "false" then
    minetest.display_chat_message(core.get_color_escape_sequence("#ff9600") .. "[TOOLBUDDY] Toolbuddy warnings are disabled.")
else
    minetest.display_chat_message(minetest.colorize("red", "[TOOLBUDDY]") .. " Toolbuddy warnings are enabled and set to: " .. modstorage:get_string("warn_lvl") .. "% wear level.")
end

minetest.register_chatcommand("toolbuddy", {
    description = "Toolbuddy tool wear alert system, will display a colored warning with sound when the tool wear gets below a set level (default is enabled at 90% wear level)",
    params = "disable | enable | help | level <level>",
    func = function(param)
        local cmd = param
        do
            local f = param:find(" ")
            if f then
                cmd = param:sub(1, f-1)
                param = param:sub(f+1)
            else
                param = ""
            end
        end
        cmd = cmd:lower()

        if cmd == "help" then
                minetest.display_chat_message("help: Show this help message.")
                minetest.display_chat_message("disable: Switch warnings off.")
                minetest.display_chat_message("enable: Switch warnings on.")
                minetest.display_chat_message("level <level>: Set the warning level for tools (from 1-99, 1 is barely worn, 99 is almost broken) (default is 90)")
                return true
        elseif cmd == "enable" then
            minetest.display_chat_message("Warnings enabled")
            modstorage:set_string("warn", "true")
        elseif cmd == "disable" then
            minetest.display_chat_message("Warnings disabled")
            modstorage:set_string("warn", "false")
        elseif cmd == "level" then
            param = tonumber(param)
            if param == nil then
                minetest.display_chat_message("You must enter a number.")
                return true
            elseif param > 99 then
                minetest.display_chat_message("You must enter a number between 1 and 99.")
                return true
            elseif param < 1 then
                minetest.display_chat_message("You must enter a number between 1 and 99.")
            else
                param = tostring(param)
                modstorage:set_string("warn_lvl", param)
                minetest.display_chat_message("Warning level set to: " .. param .. "%")
            end
        else
            minetest.display_chat_message("You must enter a valid argument")
        end
end })

minetest.register_on_item_use(function(item, pointed_thing)
    checkTool()
end)

minetest.register_on_punchnode(function(pos, node)
    checkTool()
end)

function checkTool()
    local tool = minetest.localplayer:get_wielded_item()
    local warn = modstorage:get_string("warn")

    if last_tool ~= tool:get_name() then
        last_wear = nil
        last_tool = tool:get_name()
    end

    if warn == "true" then
        if tool:get_wear() > 0 then -- Check if tool
            local wear = math.floor((tool:get_wear()/65535) * 100)
            local name = tool:get_name()
            local warn_lvl = tonumber(modstorage:get_string("warn_lvl"))
            if wear >= warn_lvl then
                if wear ~= last_wear then
                    local message = "[WARNING:] Your " .. name .. " is at " .. tostring(wear) .."% wear, it is recomended that you fix it"
                    minetest.display_chat_message(core.get_color_escape_sequence("#ff9600") .. message)
                    minetest.sound_play({name = "default_dug_metal", gain = 1.0})
                    last_wear = wear
                    return true
                end
            end
        end
    end
end

