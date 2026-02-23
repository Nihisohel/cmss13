
//patches, of any kind
/obj/item/clothing/accessory/patch
	name = "USCM patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the United States Colonial Marines."
	icon_state = "uscmpatch"
	icon = 'icons/obj/items/clothing/accessory/patches.dmi'
	accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/patches.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/patches.dmi',
	)
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/patches_flairs.dmi',
	)
	jumpsuit_hide_states = (UNIFORM_SLEEVE_CUT|UNIFORM_JACKET_REMOVED)
	flags_obj = OBJ_IS_HELMET_GARB
	worn_accessory_slot = ACCESSORY_SLOT_PATCH
	worn_accessory_limit = 4

/obj/item/clothing/accessory/patch/falcon
	name = "USCM Falling Falcons patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the Falling Falcons, the 2nd battalion of the 4th brigade of the USCM."
	icon_state = "fallingfalconspatch"
	item_state_slots = list(WEAR_AS_GARB = "falconspatch")
	flags_obj = OBJ_IS_HELMET_GARB

/obj/item/clothing/accessory/patch/devils
	name = "USCM Solar Devils patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the 3rd Battalion 'Solar Devils', part of the USCM 2nd Division, 1st Regiment."
	icon_state = "solardevilspatch"

/obj/item/clothing/accessory/patch/forecon
	name = "USCM Force Reconnaissance patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the USS Hanyut, USCM FORECON."
	icon_state = "forecon_patch"

/obj/item/clothing/accessory/patch/royal_marines
	name = "TWE Royal Marines Commando patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the royal marines commando."
	icon_state = "commandopatch"

/obj/item/clothing/accessory/patch/upp
	name = "UPP patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the Union of Progressive Peoples Armed Collective."
	icon_state = "upppatch"

/obj/item/clothing/accessory/patch/upp/airborne
	name = "UPP Airborne Reconnaissance patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the 173rd Airborne Reconnaissance Platoon."
	icon_state = "vdvpatch"

/obj/item/clothing/accessory/patch/upp/naval
	name = "UPP Naval Infantry patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the UPP Naval Infantry."
	icon_state = "navalpatch"

/obj/item/clothing/accessory/patch/ua
	name = "United Americas patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the United Americas, An economic and political giant in both the Sol system and throughout the offworld colonies, the military might of the UA is unparalleled.."
	icon_state = "uapatch"

/obj/item/clothing/accessory/patch/uasquare
	name = "United Americas patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the United Americas, An economic and political giant in both the Sol system and throughout the offworld colonies, the military might of the UA is unparalleled.."
	icon_state = "uasquare"

/obj/item/clothing/accessory/patch/falconalt
	name = "USCM Falling Falcons UA patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the Falling Falcons, the 2nd battalion of the 4th brigade of the USCM."
	icon_state = "fallingfalconsaltpatch"

/obj/item/clothing/accessory/patch/twe
	name = "Three World Empire patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women loyal to the Three World Empire, An older style symbol of the TWE."
	icon_state = "twepatch"

/obj/item/clothing/accessory/patch/uscmlarge
	name = "USCM large chest patch"
	desc = "A fire-resistant chest patch, worn by the men and women of the Falling Falcons, the 2nd battalion of the 4th brigade of the USCM."
	icon_state = "fallingfalconsbigpatch"

/obj/item/clothing/accessory/patch/army
	name = "US Army patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the United States Army."
	icon_state = "armypatch"

/obj/item/clothing/accessory/patch/army/infantry
	name = "Army Infantry patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the 1st Cavalry Division."
	icon_state = "infantrypatch"

/obj/item/clothing/accessory/patch/army/armor
	name = "Army Armor patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the 32nd Armor Brigade."
	icon_state = "armorpatch"

/obj/item/clothing/accessory/patch/wy
	name = "Weyland-Yutani patch"
	desc = "A fire-resistant black shoulder patch featuring the Weyland-Yutani logo. A symbol of loyalty to the corporation, or perhaps ironic mockery, depending on your viewpoint."
	icon_state = "wypatch"

/obj/item/clothing/accessory/patch/wysquare
	name = "Weyland-Yutani patch"
	desc = "A fire-resistant black shoulder patch featuring the Weyland-Yutani logo. A symbol of loyalty to the corporation, or perhaps ironic mockery, depending on your viewpoint."
	icon_state = "wysquare"

/obj/item/clothing/accessory/patch/wy_faction
	name = "Weyland-Yutani patch" // For WY factions like PMC's - on the right shoulder rather then left.
	desc = "A fire-resistant black shoulder patch featuring the Weyland-Yutani logo. A symbol of loyalty to the corporation."
	icon_state = "wypatch_faction"

/obj/item/clothing/accessory/patch/wy_white
	name = "Weyland-Yutani patch"
	desc = "A fire-resistant white shoulder patch featuring the Weyland-Yutani logo. A symbol of loyalty to the corporation, or perhaps ironic mockery, depending on your viewpoint."
	icon_state = "wypatch_white"

/obj/item/clothing/accessory/patch/wyfury
	name = "Weyland-Yutani Fury '161' patch"
	desc = "A fire-resistant shoulder patch. Was worn by workers and then later prisoners on the Fiorina 'Fury' 161 facility, a rare relic, after the facility went dark in 2179."
	icon_state = "fury161patch"

/obj/item/clothing/accessory/patch/upp/alt
	name = "UPP patch"
	desc = "An old fire-resistant shoulder patch, worn by the men and women of the Union of Progressive Peoples Armed Collective."
	icon_state = "upppatch_alt"

/obj/item/clothing/accessory/patch/falcon/squad_main
	name = "USCM Falling Falcons squad patch"
	desc = "A fire-resistant shoulder patch, a squad patch worn by the Falling Falcons—2nd Battalion, 4th Brigade, USCM. Stitched in squad colors."
	icon_state = "fallingfalcons_squad"
	var/dummy_icon_state = "fallingfalcons_%SQUAD%"
	var/static/list/valid_icon_states
	item_state_slots = null

/obj/item/clothing/accessory/patch/falcon/squad_main/Initialize(mapload, ...)
	. = ..()
	if(!valid_icon_states)
		valid_icon_states = icon_states(icon)
	adapt_to_squad()

/obj/item/clothing/accessory/patch/falcon/squad_main/proc/update_clothing_wrapper(mob/living/carbon/human/wearer)
	SIGNAL_HANDLER

	var/is_worn_by_wearer = recursive_holder_check(src) == wearer
	if(is_worn_by_wearer)
		update_clothing_icon()
	else
		UnregisterSignal(wearer, COMSIG_SET_SQUAD) // we can't set this in dropped, because dropping into a helmet unsets it and then it never updates

/obj/item/clothing/accessory/patch/falcon/squad_main/update_clothing_icon()
	adapt_to_squad()
	if(istype(loc, /obj/item/storage/internal) && istype(loc.loc, /obj/item/clothing/head/helmet))
		var/obj/item/clothing/head/helmet/headwear = loc.loc
		headwear.update_icon()
	return ..()

/obj/item/clothing/accessory/patch/falcon/squad_main/pickup(mob/user, silent)
	. = ..()
	adapt_to_squad()

/obj/item/clothing/accessory/patch/falcon/squad_main/equipped(mob/user, slot, silent)
	RegisterSignal(user, COMSIG_SET_SQUAD, PROC_REF(update_clothing_wrapper), TRUE)
	adapt_to_squad()
	return ..()

/obj/item/clothing/accessory/patch/falcon/squad_main/proc/adapt_to_squad()
	var/squad_color = "squad"
	var/mob/living/carbon/human/wearer = recursive_holder_check(src)
	if(istype(wearer) && wearer.assigned_squad)
		var/squad_name = lowertext(wearer.assigned_squad.name)
		if("fallingfalcons_[squad_name]" in valid_icon_states)
			squad_color = squad_name
	icon_state = replacetext(initial(dummy_icon_state), "%SQUAD%", squad_color)

/obj/item/clothing/accessory/patch/cec_patch
	name = "CEC patch"
	desc = "An old, worn and faded fire-resistant circular patch with a gold star on a split orange and red background. Once worn by members of the Cosmos Exploration Corps (CEC), a division of the UPP dedicated to exploration, resource assessment, and establishing colonies on new worlds. The patch serves as a reminder of the CEC's daring missions aboard aging starships, a symbol of perseverance in the face of adversity."
	icon_state = "cecpatch"
	item_state_slots = list(WEAR_AS_GARB = "cecpatch")

/obj/item/clothing/accessory/patch/freelancer_patch
	name = "Freelancer's Guild patch"
	desc = "A fire-resistant circular patch featuring a white skull on a vertically split black and blue background. Worn by a skilled mercenary of the Freelancers, a well-equipped group for hire across the outer colonies, known for their professionalism and neutrality. This patch is a personal memento from the wearer’s time with the group, representing a life spent navigating the dangerous world of mercenary contracts."
	icon_state = "mercpatch"
	item_state_slots = list(WEAR_AS_GARB = "mercpatch")

/obj/item/clothing/accessory/patch/merc_patch
	name = "Old Freelancer's Guild patch"
	desc = "A faded old, worn fire-resistant circular patch featuring a white skull on a vertically split black and red background. Worn by a well-equipped mercenary group for hire across the outer colonies, known for their professionalism and neutrality. The current owner’s connection to the patch is unclear—whether it was once earned as part of service, kept as a memento, or simply found, disconnected from its original wearer."
	icon_state = "mercpatch_red"
	item_state_slots = list(WEAR_AS_GARB = "mercpatch_red")

/obj/item/clothing/accessory/patch/medic_patch
	name = "Field Medic patch"
	desc = "A circular patch featuring a red cross on a white background with a bold red outline. Universally recognized as a symbol of aid and neutrality, it is worn by medics across the colonies. Whether a sign of true medical expertise, a keepsake, or merely a decoration, its presence offers a glimmer of hope in dire times."
	icon_state = "medicpatch"

/obj/item/clothing/accessory/patch/clf_patch
	name = "CLF patch"
	desc = "A circular, fire-resistant patch with a white border. The design features three white stars and a tricolor background: green, black, and red, symbolizing the Colonial Liberation Front's fight for independence and unity. This patch is worn by CLF fighters as a badge of defiance against corporate and governmental oppression, representing their struggle for a free and self-determined colonial future. Though feared and reviled by some, it remains a powerful symbol of resistance and revolution."
	icon_state = "clfpatch"

/obj/item/clothing/accessory/patch/msf_patch
	name = "Marine Space Force Herculis patch"
	desc = "A fire-resistant shoulder patch, depicting the logo of Marine Space Force III, Herculis, deployed throughout the Anglo-Japanese arm from the outer veil to the ICSC Network, this patch is often worn by any general assigned to the MSF Herculis, US Space Command and UA Allied Command Generals often have their own patches."
	icon_state = "msfpatch"

/obj/item/clothing/accessory/patch/hyperdyne_patch
	name = "Hyperdyne Corporation patch"
	desc = "A sleek corporate patch bearing the logo of the Hyperdyne Corporation—one of the most powerful conglomerates. Known for synthetic production, AI research, and deep-space logistics. Wearing this patch implies loyalty to profit over people."
	icon_state = "hyperdynepatch"
