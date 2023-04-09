--[[
    title: who_are_you
    author: Zombine
    date: 09/04/2023
    version: 1.0.0
]]

local mod = get_mod("who_are_you")

local is_self = function(account_id)
    local local_player = Managers.player:local_player(1)
    local local_player_account_id = local_player:account_id()

    return account_id == local_player_account_id
end

local style_sub_name = function(name)
    name = " (" .. name .. "){#reset()}"

    if mod:get("enable_custom_size") then
        name = "{#size(" .. mod:get("sub_name_size") .. ")}" .. name
    end

    if mod:get("enable_custom_color") then
        name = "{#color(" .. mod:get("color_r") .. "," .. mod:get("color_g") .. "," .. mod:get("color_b") .. ")}" .. name
    end

    return name
end

mod:hook_require("scripts/ui/hud/elements/player_panel_base/hud_element_player_panel_base", function(instance)
    mod:hook(instance, "_set_player_name", function(func, self, player_name, current_level)
        local display_style = mod:get("display_style")
        local player = self._player
        local name = player:name()
        local account_id = player:account_id()

        if account_id then
            local player_info = account_id and Managers.data_service.social:get_player_info_by_account_id(account_id)
            local account_name = player_info and player_info:user_display_name()
            local name_prefix = self._player_name_prefix or ""

            if display_style == "character_only" or (not mod:get("enable_display_self") and is_self(account_id)) then
                name = name
            elseif display_style == "account_only" then
                name = account_name
            elseif display_style == "character_first" then
                name =  name .. style_sub_name(account_name)
            elseif display_style == "account_first" then
                name =  account_name .. style_sub_name(name)
            end

            name = name_prefix .. name

            func(self, name, current_level)
        else
            func(self, player_name, current_level)
        end
    end)
end)