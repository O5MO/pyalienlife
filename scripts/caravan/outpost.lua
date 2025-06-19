py.on_event(py.events.on_init(), function (event)
    storage.connector_entities = storage.connector_entities or {}
    storage.outpost_by_connector = storage.outpost_by_connector or {}
end)

py.on_event(py.events.on_built(), function (event)
    local entity = event.entity
    local surface = entity.surface
    if entity.name == "outpost" then
        script.register_on_object_destroyed(entity)
        local connector_entity = surface.create_entity{
            name = "outpost-circuit-connector",
            position = entity.position,
            force = entity.force,
            create_build_effect_smoke = false,
        }
        storage.connector_entities[entity.unit_number] = connector_entity
        storage.outpost_by_connector[connector_entity.unit_number] = entity
        local red = entity.get_wire_connector(defines.wire_connector_id.circuit_red, true)
        connector_entity.get_wire_connector(defines.wire_connector_id.circuit_red, true).connect_to(red, false)
        local green = entity.get_wire_connector(defines.wire_connector_id.circuit_green, true)
        connector_entity.get_wire_connector(defines.wire_connector_id.circuit_green, true).connect_to(green, false)
    end
end)

py.on_event(py.events.on_destroyed(), function (event)
    local entity = event.entity
    local surface = entity.surface
    if entity.name == "outpost" then
        storage.connector_entities[entity.unit_number].destroy()
    end
end)

---@param parent LuaGuiElement The element to add this frame to
---@param caravan_data Caravan
local function generate_caravan_frame(parent, caravan_data)
    local entity = caravan_data.entity
    if not entity or not entity.valid then return end
    local caravan_frame = parent.add{
        type = "frame",
        style = "train_with_minimap_frame",
        direction = "vertical"
    }
    local caption_flow = caravan_frame.add{
        type = "flow",
    }
    caption_flow.style.top_margin = -4
    caption_flow.style.bottom_margin = -4
    caption_flow.style.vertical_align = "center"
    caption_flow.style.height = 28
    local title = caption_flow.add {
        name = "title",
        type = "label",
        caption = Caravan.get_name(caravan_data),
        style = "train_stop_subheader",
    }
    title.style.maximal_width = 300
    title.style.left_padding = 0

    local rename_button = caption_flow.add {
        type = "sprite-button",
        name = "py_rename_caravan_button",
        style = "mini_button_aligned_to_text_vertically_when_centered",
        sprite = "rename_icon_small_black",
        tags = {unit_number = caravan_data.entity.unit_number, maximal_width = 300}
    }
    local camera_button = caravan_frame.add{
        type = "button",
        style = "locomotive_minimap_button"
    }
    camera_button.style.size = {260, 180}
    local camera = camera_button.add{
        type = "camera",
        position = entity.position,
    }
    camera.entity = entity
    camera.style.size = {260, 180}
    local status_flow = caravan_frame.add{
        type = "frame",
        style = "deep_frame_in_shallow_frame",
    }
    status_flow.add{
        type = "button",
        style = "train_status_button",
        caption = "Heading to this stop",
    }
end

py.on_event(defines.events.on_gui_opened, function (event)
    local player = game.players[event.player_index]
    local entity = event.entity
    if entity and entity.valid and entity.name == "outpost-circuit-connector" then
        local outpost = storage.outpost_by_connector[entity.unit_number]
        player.opened = outpost
    end
end)

py.on_event(defines.events.on_gui_opened, function (event)
    local player = game.get_player(event.player_index)
    local entity = event.entity
    if not entity then return end
    if entity.name ~= "outpost" then return end
    if player.gui.relative.connected_caravan_gui then return end
    local anchor = {
        gui = defines.relative_gui_type.container_gui,
        position = defines.relative_gui_position.right
    }
    if player.gui.relative.py_global_caravan_gui then
        player.gui.relative.py_global_caravan_gui.destroy()
    end
    local main_frame = player.gui.relative.add {
        type = "frame",
        name = "py_global_caravan_gui",
        caption = {"caravan-gui.caption"},
        direction = "vertical",
        anchor = anchor
    }
    local content_frame = main_frame.add {type = "frame", name = "content_frame", direction = "vertical", style = "inside_deep_frame"}
    content_frame.style.vertically_stretchable = true
    content_frame.style.minimal_width = 424
    local content_flow = content_frame.add {type = "flow", name = "content_flow", direction = "vertical"}
    -- content_flow.style.vertical_spacing = 8
    -- content_flow.style.margin = {-4, 0, -4, 0}
    content_flow.style.vertical_align = "center"

    local caption_frame = content_flow.add {type = "frame", name = "caption_frame", direction = "horizontal", style = "subheader_frame"}
    caption_frame.style.height = 36
    caption_frame.style.horizontally_stretchable = true
    -- caption_frame.style.top_margin = -8
    -- caption_frame.style.right_margin = -12
    -- caption_frame.style.left_margin = -12
    -- caption_frame.style.left_padding = 8

    local caption_flow = caption_frame.add {type = "flow", name = "caption_flow", direction = "horizontal"}
    caption_flow.style.vertical_align = "center"

    local title = caption_flow.add {
        name = "title",
        type = "label",
        caption = "Name placeholder",
        style = "train_stop_subheader",
    }
    title.style.maximal_width = 300
    -- title.style.left_padding = 0

    local rename_button = caption_flow.add {
        type = "sprite-button",
        name = "py_rename_caravan_button",
        style = "mini_button_aligned_to_text_vertically_when_centered",
        sprite = "rename_icon_small_black",
        tags = {unit_number = entity.unit_number, maximal_width = 300}
    }
    caption_flow.add {type = "empty-widget", style = "py_empty_widget"}

    local open_map_button = caption_flow.add {
        type = "sprite-button",
        name = "py_open_map_button",
        style = "tool_button",
        sprite = "utility/map",
        tooltip = {"caravan-gui.view-on-map"},
        tags = {}
    }

    local scroll_pane = content_flow.add{
        type = "scroll-pane",
        style = "trains_scroll_pane"
    }
    local tabbed_pane = scroll_pane.add {
        type = "tabbed-pane",
    }
    tabbed_pane.style.horizontally_stretchable = true
    local tab1 = tabbed_pane.add{type="tab", caption="Tab 1"}
    local tab2 = tabbed_pane.add{type="tab", caption="Tab 2"}
    local table1 = tabbed_pane.add {
        type = "table",
        column_count = 2,
        style = "trains_widget_table",
        -- draw_vertical_lines = true,
        -- draw_horizontal_lines = true,
    }
    local table2 = tabbed_pane.add {
        type = "table",
        column_count = 2,
        style = "trains_widget_table",
    }
    local k, caravan = next(storage.caravans)
    generate_caravan_frame(table1, caravan)
    local _, caravan = next(storage.caravans, k)
    generate_caravan_frame(table1, caravan)
    tabbed_pane.add_tab(tab1, table1)
    tabbed_pane.add_tab(tab2, table2)
    tabbed_pane.selected_tab_index = 1
    -- Caravan.build_gui_connected(player, entity, anchor)
end)