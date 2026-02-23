//Medals for the unworthy marines yep

/obj/item/clothing/accessory/medal
	name = "medal"
	desc = "A medal."
	icon_state = "bronze_service"
	item_state = "bronze"
	icon = 'icons/obj/items/clothing/accessory/medals.dmi'
	inv_overlay_icon = 'icons/obj/items/clothing/accessory/inventory_overlays/medals.dmi'
	accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/medals.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/medals.dmi'
	)
	var/recipient_name //name of the person this is awarded to.
	var/recipient_rank
	var/medal_citation
	worn_accessory_slot = ACCESSORY_SLOT_MEDAL
	high_visibility = TRUE
	jumpsuit_hide_states = UNIFORM_JACKET_REMOVED
	worn_accessory_limit = 2
	var/awarding_faction

/obj/item/clothing/accessory/medal/on_attached(obj/item/clothing/S, mob/living/user, silent)
	. = ..()
	if(.)
		RegisterSignal(S, COMSIG_ITEM_EQUIPPED, PROC_REF(remove_medal))

/obj/item/clothing/accessory/medal/proc/remove_medal(obj/item/clothing/C, mob/user, slot)
	SIGNAL_HANDLER
	if(user.real_name != recipient_name && (slot == WEAR_BODY || slot == WEAR_JACKET))
		C.remove_accessory(user, src)
		user.drop_held_item(src)

/obj/item/clothing/accessory/medal/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(.)
		UnregisterSignal(C, COMSIG_ITEM_EQUIPPED)

/obj/item/clothing/accessory/medal/attack(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!(istype(H) && istype(user)))
		return ..()
	if(recipient_name != H.real_name)
		to_chat(user, SPAN_WARNING("[src] wasn't awarded to [H]."))
		return

	var/obj/item/clothing/U
	if(H.wear_suit && H.wear_suit.can_attach_accessory(src)) //Prioritises topmost garment, IE service jackets, if possible.
		U = H.wear_suit
	else
		U = H.w_uniform //Will be null if no uniform. That this allows medal ceremonies in which the hero is wearing no pants is correct and just.
	if(!U)
		if(user == H)
			to_chat(user, SPAN_WARNING("You aren't wearing anything you can pin [src] to."))
		else
			to_chat(user, SPAN_WARNING("[H] isn't wearing anything you can pin [src] to."))
		return

	if(user == H)
		user.visible_message(SPAN_NOTICE("[user] pins [src] to \his [U.name]."),
		SPAN_NOTICE("You pin [src] to your [U.name]."))

	else
		if(user.action_busy)
			return
		if(user.a_intent != INTENT_HARM)
			user.affected_message(H,
			SPAN_NOTICE("You start to pin [src] onto [H]."),
			SPAN_NOTICE("[user] starts to pin [src] onto you."),
			SPAN_NOTICE("[user] starts to pin [src] onto [H]."))
			if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, H))
				return
			if(!(U == H.w_uniform || U == H.wear_suit))
				to_chat(user, SPAN_WARNING("[H] took off \his [U.name] before you could finish pinning [src] to it."))
				return
			user.affected_message(H,
			SPAN_NOTICE("You pin [src] to [H]'s [U.name]."),
			SPAN_NOTICE("[user] pins [src] to your [U.name]."),
			SPAN_NOTICE("[user] pins [src] to [H]'s [U.name]."))

		else
			user.affected_message(H,
			SPAN_ALERT("You start to pin [src] to [H]."),
			SPAN_ALERT("[user] starts to pin [src] to you."),
			SPAN_ALERT("[user] starts to pin [src] to [H]."))
			if(!do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_HOSTILE, H))
				return
			if(!(U == H.w_uniform || U == H.wear_suit))
				to_chat(user, SPAN_WARNING("[H] took off \his [U.name] before you could finish pinning [src] to \him."))
				return
			user.affected_message(H,
			SPAN_DANGER("You slam the [src.name]'s pin through [H]'s [U.name] and into \his chest."),
			SPAN_DANGER("[user] slams the [src.name]'s pin through your [U.name] and into your chest!"),
			SPAN_DANGER("[user] slams the [src.name]'s pin through [H]'s [U.name] and into \his chest."))

			/*Some duplication from punch code due to attack message and damage stats.
			This does cut damage and awarding multiple medals like this to the same person will cause bleeding.*/
			H.last_damage_data = create_cause_data("macho bullshit", user)
			user.animation_attack_on(H)
			user.flick_attack_overlay(H, "punch")
			playsound(user.loc, "punch", 25, 1)
			H.apply_damage(5, BRUTE, "chest", 1)

			if(!H.stat && H.pain.feels_pain)
				if(prob(35))
					INVOKE_ASYNC(H, TYPE_PROC_REF(/mob, emote), "pain")
				else
					INVOKE_ASYNC(H, TYPE_PROC_REF(/mob, emote), "me", 1, "winces.")

	if(U.can_attach_accessory(src) && user.drop_held_item())
		U.attach_accessory(H, src, TRUE)

/obj/item/clothing/accessory/medal/can_attach_to(mob/user, obj/item/clothing/C)
	if(user.real_name != recipient_name)
		return FALSE
	return TRUE

/obj/item/clothing/accessory/medal/get_examine_text(mob/user)
	. = ..()

	var/citation_to_read = ""
	if(medal_citation)
		citation_to_read = "The citation reads \'[medal_citation]\'."

	. += "Awarded to: \'[recipient_rank] [recipient_name]\'. [citation_to_read]"

/obj/item/clothing/accessory/medal/ribbon
	name = "award ribbon"
	desc = "A military award ribbon."

/obj/item/clothing/accessory/medal/ribbon/commendation
	name = MARINE_RIBBON_COMMENDATION
	desc = "A ribbon awarded to commend conduct and actions of note, often given alongside a formal letter of commendation. This is the most basic award given by the USCM."
	icon_state = "ribbon_commendation"
	awarding_faction = FACTION_MARINE

/obj/item/clothing/accessory/medal/ribbon/leadership
	name = MARINE_RIBBON_LEADERSHIP
	desc = "A ribbon given to officers, NCOs, or squad leaders whose coordination, decision-making, or morale-keeping played a critical role in their unit's success or survival."
	icon_state = "ribbon_leadership"
	awarding_faction = FACTION_MARINE

/obj/item/clothing/accessory/medal/ribbon/proficiency
	name = MARINE_RIBBON_PROFICIENCY
	desc = "A ribbon awarded for outstanding technical expertise in the field. Engineering, medical, or logistics personnel whose skill or innovation directly contributed to mission success."
	icon_state = "ribbon_proficiency"
	awarding_faction = FACTION_MARINE

/obj/item/clothing/accessory/medal/purple_heart
	name = MARINE_MEDAL_PURPLE_HEART
	desc = "Awarded to those wounded or killed in action. A solemn token of sacrifice and resilience given in recognition of the physical and personal cost of service."
	icon_state = "purple_heart"
	awarding_faction = FACTION_MARINE

/obj/item/clothing/accessory/medal/bronze
	name = "bronze medal"
	desc = "A bronze medal."
	icon_state = "bronze"

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A silver medal."
	icon_state = "silver"
	item_state = "silver"

/obj/item/clothing/accessory/medal/silver/star
	name = MARINE_MEDAL_SILVER_STAR
	desc = "Awarded for conspicuous gallantry in action. The Silver Star recognizes those who go beyond the call of duty: charging into danger, holding the line when all seems lost, or saving lives under relentless enemy fire."
	icon_state = "silver_star"
	awarding_faction = FACTION_MARINE

/obj/item/clothing/accessory/medal/silver/valor
	name = MARINE_MEDAL_VALOR
	desc = "For acts of courage performed during combat operations. Recognizes marines who display calm, determination, and bravery under fire, contributing to the survival and morale of their squad."
	awarding_faction = FACTION_MARINE

/obj/item/clothing/accessory/medal/gold/corporate_award
	name = WY_MEDAL_AWARD_1
	desc = "A small gold corporate badge awarded for notable service in the interests of Weyland-Yutani."
	icon_state = "corporate_award"
	awarding_faction = FACTION_WY

/obj/item/clothing/accessory/medal/gold/corporate_award2
	name = WY_MEDAL_AWARD_2
	desc = "A large gold corporate badge awarded for notable service in the interests of Weyland-Yutani."
	icon_state = "corporate_award2"
	awarding_faction = FACTION_WY

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A prestigious golden medal."
	icon_state = "gold"
	item_state = "gold"

/obj/item/clothing/accessory/medal/gold/cross
	name = MARINE_MEDAL_GALACTIC_CROSS
	desc = "The second highest decoration within the USCM. Granted for acts of valor performed under extreme conditions. When the mission's success or the survival of fellow marines hinged upon extraordinary courage and quick thinking."
	icon_state = "ua_cross"
	awarding_faction = FACTION_MARINE

/obj/item/clothing/accessory/medal/platinum
	name = "platinum medal"
	desc = "A very prestigious platinum medal, only able to be handed out by generals due to special circumstances."
	icon_state = "platinum"
	item_state = "platinum"

/obj/item/clothing/accessory/medal/platinum/honor
	name = MARINE_MEDAL_HONOR
	desc = "The highest distinction awarded by the United States Colonial Marine Corps. Bestowed upon those whose actions demonstrate unparalleled bravery, self-sacrifice, and devotion to duty - often in the face of certain death. To wear this medal is to stand among legends of the Corps."
	awarding_faction = "USCM HC"

//Legacy medals.
//Keeping in code as to allow medal records to display correctly, but won't be issued further.
/obj/item/clothing/accessory/medal/legacy
	name = "legacy medal"
	desc = "An old and disused award."

/obj/item/clothing/accessory/medal/legacy/distinguished_conduct
	name = MARINE_LEGACY_MEDAL_CONDUCT
	desc = "A bronze medal awarded for distinguished conduct. Whilst a great honor, this is one of the most basic awards given by the USCM."
	icon_state = "conduct"

/obj/item/clothing/accessory/medal/legacy/bronze_heart
	name = MARINE_LEGACY_MEDAL_BRONZE_HEART
	desc = "A bronze heart-shaped medal awarded for sacrifice. It is often awarded posthumously or for severe injury in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/legacy/heroism
	name = MARINE_LEGACY_MEDAL_HEROISM
	desc = "An extremely rare golden medal awarded only by the USCM. To receive such a medal is the highest honor and as such, very few exist."
	icon_state = "heroism"

//Playtime Service Medals
/obj/item/clothing/accessory/medal/bronze/service
	name = "bronze service medal"
	desc = "A bronze medal awarded for a marine's service within the USCM. It is a very common medal, and is typically the first medal a marine would receive."
	icon_state = "bronze_service"

/obj/item/clothing/accessory/medal/silver/service
	name = "silver service medal"
	desc = "A shiny silver medal awarded for a marine's service within the USCM. It is a somewhat common medal which signifies the amount of time a marine has spent in the line of duty."
	icon_state = "silver_service"

/obj/item/clothing/accessory/medal/gold/service
	name = "gold service medal"
	desc = "A prestigious gold medal awarded for a marine's service within the USCM. It is a rare medal which signifies the amount of time a marine has spent in the line of duty."
	icon_state = "gold_service"

/obj/item/clothing/accessory/medal/platinum/service
	name = "platinum service medal"
	desc = "The highest service medal that can be awarded to a marine; such medals are hand-given by USCM Generals to a marine. It signifies the sheer amount of time a marine has spent in the line of duty."
	icon_state = "platinum_service"

