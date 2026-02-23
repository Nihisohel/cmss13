// Armbands, watches, anything on the arms that arent patches of course

/obj/item/clothing/accessory/armband
	name = "red armband"
	desc = "A fancy red armband!"
	icon_state = "red"
	icon = 'icons/obj/items/clothing/accessory/armbands.dmi'
	inv_overlay_icon = 'icons/obj/items/clothing/accessory/inventory_overlays/armbands.dmi'
	accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/armbands.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/armbands.dmi'
	)
	worn_accessory_slot = ACCESSORY_SLOT_ARMBAND
	worn_accessory_limit = 2

/obj/item/clothing/accessory/armband/cargo
	name = "cargo armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is brown."
	icon_state = "cargo"

/obj/item/clothing/accessory/armband/engine
	name = "engineering armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is orange with a reflective strip!"
	icon_state = "engie"

/obj/item/clothing/accessory/armband/science
	name = "science armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is purple."
	icon_state = "rnd"

/obj/item/clothing/accessory/armband/hydro
	name = "hydroponics armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is green and blue."
	icon_state = "hydro"

/obj/item/clothing/accessory/armband/med
	name = "medical armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is white."
	icon_state = "med"

/obj/item/clothing/accessory/armband/medgreen
	name = "EMT armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is white and green."
	icon_state = "medgreen"

/obj/item/clothing/accessory/armband/nurse
	name = "nurse armband"
	desc = "An armband, worn by the rookie nurses to display they are still not doctors. This one is dark red."
	icon_state = "nurse"

/obj/item/clothing/accessory/armband/squad
	name = "squad armband"
	desc = "An armband in squad colors, worn for ease of idenfication."
	icon_state = "armband_squad"
	var/dummy_icon_state = "armband_%SQUAD%"
	var/static/list/valid_icon_states
	item_state_slots = null

/obj/item/clothing/accessory/armband/squad/Initialize(mapload, ...)
	. = ..()
	if(!valid_icon_states)
		valid_icon_states = icon_states(icon)
	adapt_to_squad()

/obj/item/clothing/accessory/armband/squad/proc/update_clothing_wrapper(mob/living/carbon/human/wearer)
	SIGNAL_HANDLER

	var/is_worn_by_wearer = recursive_holder_check(src) == wearer
	if(is_worn_by_wearer)
		update_clothing_icon()
	else
		UnregisterSignal(wearer, COMSIG_SET_SQUAD)

/obj/item/clothing/accessory/armband/squad/update_clothing_icon()
	adapt_to_squad()

/obj/item/clothing/accessory/armband/squad/pickup(mob/user, silent)
	. = ..()
	adapt_to_squad()

/obj/item/clothing/accessory/armband/squad/equipped(mob/user, slot, silent)
	RegisterSignal(user, COMSIG_SET_SQUAD, PROC_REF(update_clothing_wrapper), TRUE)
	adapt_to_squad()
	return ..()

/obj/item/clothing/accessory/armband/squad/proc/adapt_to_squad()
	if(has_suit)
		has_suit.overlays -= get_inv_overlay()
	var/squad_color = "squad"
	var/mob/living/carbon/human/wearer = recursive_holder_check(src)
	if(istype(wearer) && wearer.assigned_squad)
		var/squad_name = lowertext(wearer.assigned_squad.name)
		if("armband_[squad_name]" in valid_icon_states)
			squad_color = squad_name
	icon_state = replacetext(initial(dummy_icon_state), "%SQUAD%", squad_color)
	inv_overlay = image("icon" = inv_overlay_icon, "icon_state" = "[item_state? "[item_state]" : "[icon_state]"]")
	if(has_suit)
		has_suit.overlays += get_inv_overlay()

/obj/item/clothing/accessory/armband/mp
	name = "MP armband"
	desc = "An armband worn by USCM Military Police officers on military installations. It is usually also worn by those from the provost office."
	icon_state = "armband_mp"


/*
Wrist Accessories
*/

/obj/item/clothing/accessory/wrist
	name = "bracelet"
	desc = "A simple bracelet made from a strip of fabric."
	icon = 'icons/obj/items/clothing/accessory/wrist_accessories.dmi'
	icon_state = "bracelet"
	inv_overlay_icon = null
	worn_accessory_slot = ACCESSORY_SLOT_WRIST_L
	worn_accessory_limit = 4
	var/which_wrist = "left wrist"

/obj/item/clothing/accessory/wrist/get_examine_text(mob/user)
	. = ..()

	switch(worn_accessory_slot)
		if(ACCESSORY_SLOT_WRIST_L)
			which_wrist = "left wrist"
		if(ACCESSORY_SLOT_WRIST_R)
			which_wrist = "right wrist"
	. += "It will be worn on the [which_wrist]."

/obj/item/clothing/accessory/wrist/additional_examine_text()
	return "on the [which_wrist]."

/obj/item/clothing/accessory/wrist/attack_self(mob/user)
	..()

	switch(worn_accessory_slot)
		if(ACCESSORY_SLOT_WRIST_L)
			worn_accessory_slot = ACCESSORY_SLOT_WRIST_R
			to_chat(user, SPAN_NOTICE("[src] will be worn on the right wrist."))
		if(ACCESSORY_SLOT_WRIST_R)
			worn_accessory_slot = ACCESSORY_SLOT_WRIST_L
			to_chat(user, SPAN_NOTICE("[src] will be worn on the left wrist."))

/obj/item/clothing/accessory/wrist/watch
	name = "digital wrist watch"
	desc = "A cheap 24-hour only digital wrist watch. It has a crappy red display, great for looking at in the dark!"
	icon = 'icons/obj/items/clothing/accessory/watches.dmi'
	icon_state = "cheap_watch"
	worn_accessory_limit = 1 // though, this means you can wear a watch on each wrist, which should be fine, although you might look stupid for doing this

/obj/item/clothing/accessory/wrist/watch/get_examine_text(mob/user)
	. = ..()

	. += "It reads: [SPAN_NOTICE("[worldtime2text()]")]"

/obj/item/clothing/accessory/wrist/watch/additional_examine_text()
	. = ..()

	. += " It reads: [SPAN_NOTICE("[worldtime2text()]")]"
