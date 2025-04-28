local util = require "util"

RECIPE {
    type = "recipe",
    name = "outpost",
    energy_required = 1,
    category = "crafting",
    enabled = false,
    ingredients = {
        {type = "item", name = "steel-plate",    amount = 5},
        {type = "item", name = "small-parts-01", amount = 50},
        {type = "item", name = "wooden-chest",   amount = 6},
        {type = "item", name = "concrete",       amount = 20},
        {type = "item", name = "glass",          amount = 5},
    },
    result = "outpost"
}:add_unlock("zoology")

ITEM {
    type = "item",
    name = "outpost",
    icon = "__pyalienlifegraphics2__/graphics/icons/outpost.png",
    icon_size = 64,
    subgroup = "py-alienlife-buildings-others",
    order = "b-a",
    place_result = "outpost",
    stack_size = 10
}

data:extend {{
    inventory_type = "with_filters_and_bar",
    scale_info_icons = true,
    name = "outpost",
    type = "container",
    close_sound = {
        filename = "__base__/sound/metallic-chest-close.ogg",
        volume = 0.43
    },
    collision_box = {
        {
            -2.9,
            -2.9
        },
        {
            2.9,
            2.9
        }
    },
    corpse = "big-remnants",
    damaged_trigger_effect = {
        damage_type_filters = "fire",
        entity_name = "spark-explosion",
        offset_deviation = {
            {
                -0.5,
                -0.5
            },
            {
                0.5,
                0.5
            }
        },
        offsets = {
            {
                0,
                1
            }
        },
        type = "create-entity"
    },
    dying_explosion = "steel-chest-explosion",
    flags = {
        "placeable-neutral",
        "player-creation",
        "get-by-unit-number"
    },
    icon = "__pyalienlifegraphics2__/graphics/icons/outpost.png",
    icon_size = 64,
    inventory_size = 30,
    max_health = 600,
    minable = {
        mining_time = 0.2,
        result = "outpost"
    },
    open_sound = {
        filename = "__base__/sound/metallic-chest-open.ogg",
        volume = 0.43
    },
    picture = {
        layers = {
            {
                filename = "__pyalienlifegraphics2__/graphics/entity/outpost/off.png",
                height = 224,
                width = 224,
                priority = "extra-high",
                shift = util.by_pixel(16, -16),
            },
        }
    },
    resistances = {
        {
            percent = 90,
            type = "fire"
        },
        {
            percent = 60,
            type = "impact"
        }
    },
    selection_box = {
        {
            -3.0,
            -3.0
        },
        {
            3.0,
            3.0
        }
    },
    circuit_connector = table.deepcopy(data.raw.container["steel-chest"].circuit_connector), -- TODO
    circuit_wire_max_distance = 9,
}}

-- TODO: temporary description, update if necessary
-- A hidden proxy container for the purposes of reading outpost contents without outpost gui having "circuit connections" window
-- Note that outpost itself can also be connected to circuit network, but this connection is moved onto the proxy upon opening gui
data:extend{{
    type = "proxy-container",
    name = "outpost-circuit-connector",
    draw_inventory_content = false,
    circuit_connector = table.deepcopy(data.raw.container["steel-chest"].circuit_connector), -- TODO
    circuit_wire_max_distance = data.raw.container["outpost"].circuit_wire_max_distance,
    collision_mask = {layers = {}},
    -- selection_box = {{1,1},{3,3}}
}}