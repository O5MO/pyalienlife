--PHYTHOPLANCTON--
RECIPE {
    type = "recipe",
    name = "phytoplankton-3",
    category = "plankton",
    enabled = false,
    energy_required = 15,
    ingredients = {
        {type = "fluid", name = "flue-gas", amount = 100, fluidbox_index = 1},
        {type = "fluid", name = "water",    amount = 500, fluidbox_index = 2}
    },
    results = {
        {type = "fluid", name = "phytoplankton", amount = 20}
    },
    main_product = "phytoplankton",
    subgroup = "py-alienlife-plants",
    order = "b"
}:add_unlock("microbiology-mk03")
