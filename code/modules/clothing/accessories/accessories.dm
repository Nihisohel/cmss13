// Welcome to the parent file for accessories
// Anything that doesn't fit in the rest of
// the other files in the directory
// goes in this file with the parent :)
// - nihi

/obj/item/clothing/accessory
	name = "accessory"
	desc = "Ahelp if you see this."
	icon = 'icons/obj/items/clothing/accessory/ties.dmi'
	w_class = SIZE_SMALL
	var/image/inv_overlay = null //overlay used when attached to clothing.
	var/obj/item/clothing/has_suit = null //the suit the tie may be attached to
	var/list/mob_overlay = list()
	var/overlay_state = null
	var/inv_overlay_icon = 'icons/obj/items/clothing/accessory/inventory_overlays/ties.dmi'
	var/list/accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/ties.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/ties.dmi'
	)
	///Jumpsuit flags that cause the accessory to be hidden. format: "x" OR "(x|y|z)" (w/o quote marks).
	var/jumpsuit_hide_states
	var/high_visibility //if it should appear on examine without detailed view
	var/removable = TRUE
	flags_equip_slot = SLOT_ACCESSORY
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/ties_monkey.dmi')
	var/original_item_path = /obj/item/clothing/accessory
	worn_accessory_slot = 1

/obj/item/clothing/accessory/attack_self(mob/user)
	if(can_become_accessory)
		revert_from_accessory(user)
		return
	return ..()

/obj/item/clothing/accessory/Initialize()
	. = ..()
	inv_overlay = image("icon" = inv_overlay_icon, "icon_state" = "[item_state? "[item_state]" : "[icon_state]"]")
	flags_atom |= USES_HEARING

/obj/item/clothing/accessory/Destroy()
	if(has_suit)
		has_suit.remove_accessory()
	inv_overlay = null
	. = ..()

/obj/item/clothing/accessory/proc/can_attach_to(mob/user, obj/item/clothing/C)
	return TRUE

//when user attached an accessory to clothing/clothes
/obj/item/clothing/accessory/proc/on_attached(obj/item/clothing/clothes, mob/living/user, silent)
	if(!istype(clothes))
		return
	has_suit = clothes
	forceMove(has_suit)
	has_suit.overlays += get_inv_overlay()

	if(user)
		if(!silent)
			to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [has_suit]."))
		src.add_fingerprint(user)

	if(ismob(clothes.loc))
		var/mob/wearer = clothes.loc
		if(LAZYLEN(actions))
			for(var/datum/action/action in actions)
				action.give_to(wearer)
	return TRUE

/obj/item/clothing/accessory/proc/on_removed(mob/living/user, obj/item/clothing/clothes)
	if(!has_suit)
		return

	if(ismob(clothes.loc))
		var/mob/wearer = clothes.loc
		if(LAZYLEN(actions))
			for(var/datum/action/action in actions)
				action.remove_from(wearer)

	has_suit.overlays -= get_inv_overlay()
	has_suit = null
	if(usr)
		usr.put_in_hands(src)
		src.add_fingerprint(usr)
	else
		src.forceMove(get_turf(src))
	return TRUE

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return //we aren't an object on the ground so don't call parent. If overriding to give special functions to a host item, return TRUE so that the host doesn't continue its own attack_hand.
	..()

///Extra text to append when attached to another clothing item and the host clothing is examined.
/obj/item/clothing/accessory/proc/additional_examine_text()
	return "attached to it."

// Misc

/obj/item/clothing/accessory/dogtags
	name = "Attachable Dogtags"
	desc = "A robust pair of dogtags to be worn around the neck of the United States Colonial Marines, however due to a combination of budget reallocation, Marines losing their dogtags, and multiple incidents of marines swallowing their tags, they now attach to the uniform or armor."
	icon_state = "dogtag"
	icon = 'icons/obj/items/clothing/accessory/misc.dmi'
	inv_overlay_icon = 'icons/obj/items/clothing/accessory/inventory_overlays/misc.dmi'
	accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/misc.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/misc.dmi'
	)
	worn_accessory_slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/poncho
	name = "USCM Poncho"
	desc = "The standard USCM poncho has variations for every climate. Custom fitted to be attached to standard USCM armor variants it is comfortable, warming or cooling as needed, and well-fit. A marine couldn't ask for more. Affectionately referred to as a \"woobie\"."
	icon_state = "poncho"
	icon = 'icons/obj/items/clothing/accessory/ponchos.dmi'
	inv_overlay_icon = 'icons/obj/items/clothing/accessory/inventory_overlays/ponchos.dmi'
	accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/ponchos.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/ponchos.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items_by_map/jungle_righthand.dmi'
	)
	worn_accessory_slot = ACCESSORY_SLOT_PONCHO
	flags_atom = MAP_COLOR_INDEX

/obj/item/clothing/accessory/poncho/Initialize()
	. = ..()
	// Only do this for the base type '/obj/item/clothing/accessory/poncho'.
	select_gamemode_skin(/obj/item/clothing/accessory/poncho)
	inv_overlay = image("icon" = inv_overlay_icon, "icon_state" = "[icon_state]")
	update_icon()

/obj/item/clothing/accessory/poncho/green
	icon_state = "poncho"

/obj/item/clothing/accessory/poncho/brown
	icon_state = "d_poncho"

/obj/item/clothing/accessory/poncho/black
	icon_state = "u_poncho"

/obj/item/clothing/accessory/poncho/blue
	icon_state = "c_poncho"

/obj/item/clothing/accessory/poncho/purple
	icon_state = "s_poncho"

/obj/item/clothing/accessory/clf_cape
	name = "torn CLF flag"
	desc = "A torn up CLF flag with a pin that allows it to be worn as a cape."
	icon_state = "clf_cape"
	icon = 'icons/obj/items/clothing/accessory/ponchos.dmi'
	inv_overlay_icon = 'icons/obj/items/clothing/accessory/inventory_overlays/ponchos.dmi'
	accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/ponchos.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/ponchos.dmi'
	)
	worn_accessory_slot = ACCESSORY_SLOT_PONCHO

/*
	Holobadges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on the badge with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/holobadge

	name = "holobadge"
	desc = "This glowing blue badge marks the holder as THE LAW."
	icon_state = "holobadge"
	icon = 'icons/obj/items/clothing/accessory/misc.dmi'
	inv_overlay_icon = 'icons/obj/items/clothing/accessory/inventory_overlays/misc.dmi'
	accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/misc.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/misc.dmi'
	)
	flags_equip_slot = SLOT_WAIST
	jumpsuit_hide_states = UNIFORM_JACKET_REMOVED
	worn_accessory_slot = ACCESSORY_SLOT_DECOR

	var/stored_name = null

/obj/item/clothing/accessory/holobadge/cord
	icon_state = "holobadge-cord"
	flags_equip_slot = SLOT_FACE
	accessory_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/accessory/misc.dmi',
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/misc.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/misc.dmi'
	)

/obj/item/clothing/accessory/holobadge/attack_self(mob/user)
	..()

	if(!stored_name)
		to_chat(user, "Waving around a badge before swiping an ID would be pretty pointless.")
		return
	if(isliving(user))
		user.visible_message(SPAN_DANGER("[user] displays their Wey-Yu Internal Security Legal Authorization Badge.\nIt reads: [stored_name], Wey-Yu Security."),SPAN_DANGER("You display your Wey-Yu Internal Security Legal Authorization Badge.\nIt reads: [stored_name], Wey-Yu Security."))

/obj/item/clothing/accessory/holobadge/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/card/id))

		var/obj/item/card/id/id_card = null

		if(istype(O, /obj/item/card/id))
			id_card = O

		if(ACCESS_MARINE_BRIG in id_card.access)
			to_chat(user, "You imprint your ID details onto the badge.")
			stored_name = id_card.registered_name
			name = "holobadge ([stored_name])"
			desc = "This glowing blue badge marks [stored_name] as THE LAW."
		else
			to_chat(user, "[src] rejects your insufficient access rights.")
		return
	..()

/obj/item/clothing/accessory/holobadge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message(SPAN_DANGER("[user] invades [M]'s personal space, thrusting [src] into their face insistently."),SPAN_DANGER("You invade [M]'s personal space, thrusting [src] into their face insistently. You are the law."))

/obj/item/storage/box/holobadge // re-org this out in the future
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."

/obj/item/storage/box/holobadge/New()
	new /obj/item/clothing/accessory/holobadge(src)
	new /obj/item/clothing/accessory/holobadge(src)
	new /obj/item/clothing/accessory/holobadge(src)
	new /obj/item/clothing/accessory/holobadge(src)
	new /obj/item/clothing/accessory/holobadge/cord(src)
	new /obj/item/clothing/accessory/holobadge/cord(src)
	..()
	return
