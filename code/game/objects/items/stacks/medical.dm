/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items/medical_stacks.dmi'
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/medical.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	amount = 10
	max_amount = 10
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	attack_speed = 3
	var/heal_brute = 0
	var/heal_burn = 0
	var/alien = FALSE

/obj/item/stack/medical/attack_self(mob/user)
	..()
	attack(user, user) // ok bro

/obj/item/stack/medical/attack(mob/living/carbon/person as mob, mob/user as mob)
	if(!istype(person))
		to_chat(user, SPAN_DANGER("\The [src] cannot be applied to [person]!"))
		return TRUE

	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE

	var/mob/living/carbon/human/treating = person
	var/obj/limb/affecting = treating.get_limb(user.zone_selected)

	if(HAS_TRAIT(treating, TRAIT_FOREIGN_BIO) && !alien)
		to_chat(user, SPAN_WARNING("\The [src] is incompatible with the biology of [treating]!"))
		return TRUE

	if(!affecting)
		to_chat(user, SPAN_WARNING("[treating] has no [parse_zone(user.zone_selected)]!"))
		return TRUE

	if(affecting.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		to_chat(user, SPAN_WARNING("This isn't useful at all on a robotic limb."))
		return TRUE

	treating.UpdateDamageIcon()

// apply_treatment proc so theres no fucking duplicates of the same code every goddamn time i scroll down
/obj/item/stack/medical/proc/apply_treatment(mob/living/carbon/human/target, mob/user, obj/limb/affecting, treatment_type, heal_brute_amount, heal_burn_amount, advanced = FALSE, success_sound, success_message, no_wound_message, wound_treated_message)
	if(affecting.get_incision_depth())
		to_chat(user, SPAN_NOTICE("[target]'s [affecting.display_name] is cut open, you'll need more than a bandage!"))
		return FALSE

	var/possessive = "[user == target ? "your" : "\the [target]'s"]"
	var/treatment_check
	switch(treatment_type) // in limbs.dm, also rewrote it a little so i dunno if it breaks something
		if("bandaging")
			treatment_check = affecting.bandage(advanced, TRUE)
		if("salving")
			treatment_check = affecting.salve(advanced, TRUE)

	switch(treatment_check)
		if(WOUNDS_ALREADY_TREATED)
			to_chat(user, SPAN_WARNING("[wound_treated_message] [possessive] [affecting.display_name] have already been treated."))
			return FALSE
		if(WOUNDS_NOT_FOUND)
			to_chat(user, SPAN_WARNING("[no_wound_message] [possessive] [affecting.display_name]."))
			return FALSE
		if(!WOUNDS_TREATED) // Something else went wrong, or no wounds to treat.
			to_chat(user, SPAN_WARNING("[no_wound_message] [possessive] [affecting.display_name] ERROR."))
			return FALSE

	// i guess, you never really know if people want to add functionality for medical items for both brute and burn
	var/heal_brute_final = heal_brute_amount
	var/heal_burn_final = heal_burn_amount

	var/do_after_result
	var/time_to_take = 6 SECONDS

	if(user.skills && skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
		time_to_take -= user.skills.get_skill_level(SKILL_MEDICAL) SECONDS //medical levels reduce healaing time by a single second per level

	if(target != user) // if the target is not the user, reduce the time it takes
		time_to_take -= 1 SECONDS

		// medical levels also increase healing by a single point per level
		switch(treatment_type)
			if("bandaging")
				heal_brute_final += user.skills.get_skill_level(SKILL_MEDICAL)
			if("salving")
				heal_burn_final += user.skills.get_skill_level(SKILL_MEDICAL)

	if(advanced)
		if(user.skills && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You start fumbling with \the [src]..."))
			time_to_take += 1.5 SECONDS
		else
			to_chat(user, SPAN_HELPFUL("You start expertly applying \the [src]..."))
			time_to_take -= 1 SECONDS

		if(target == user && (affecting.name in list("l_leg", "r_leg", "r_foot", "l_foot")))
			do_after_result = do_after(user, time_to_take, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL, status_effect = SUPERSLOW)
		else if(target == user) // we can mooooooove while treating ourselves yippee
			do_after_result = do_after(user, time_to_take, (INTERRUPT_NO_NEEDHAND & (~INTERRUPT_MOVED)), BUSY_ICON_FRIENDLY, target, (INTERRUPT_NONE & (~INTERRUPT_MOVED)), BUSY_ICON_MEDICAL, status_effect = SLOW)
		else
			do_after_result = do_after(user, time_to_take, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)

	else
		time_to_take -= 3 SECONDS
		if(user.skills && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
			to_chat(user, SPAN_HELPFUL("You start applying \the [src]..."))
		else
			to_chat(user, SPAN_HELPFUL("You start expertly applying \the [src]..."))
			time_to_take -= 0.5 SECONDS

		if(target == user && (affecting.name in list("l_leg", "r_leg", "r_foot", "l_foot")))
			do_after_result = do_after(user, time_to_take, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL, status_effect = SUPERSLOW)
		else if(target == user)
			do_after_result = do_after(user, time_to_take, (INTERRUPT_NO_NEEDHAND & (~INTERRUPT_MOVED)), BUSY_ICON_FRIENDLY, target, (INTERRUPT_NONE & (~INTERRUPT_MOVED)), BUSY_ICON_MEDICAL, status_effect = SLOW)
		else
			do_after_result = do_after(user, time_to_take, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)

	to_chat(user, "time_to_take: [time_to_take] ") //debug

	if(do_after_result)
		var/possessive_their = "[user == target ? target.p_their() : "\the [target]'s"]"

		var/treatment_result
		switch(treatment_type)
			if("bandaging")
				treatment_result = affecting.bandage(advanced)
			if("salving")
				treatment_result = affecting.salve(advanced)

		switch(treatment_result)
			if(WOUNDS_TREATED)
				user.affected_message (target,
					SPAN_HELPFUL("You [success_message] [possessive] <b>[affecting.display_name]</b>[advanced ? " with bioglue" : ""]."),
					SPAN_HELPFUL("[user] [success_message] your <b>[affecting.display_name]</b>[advanced ? " with bioglue" : ""]."),
					SPAN_NOTICE("[user] [success_message] [possessive_their] wounds [advanced ? " with bioglue" : ""].")) // dont display the limb, that shit can disrupt the chatbar

				if(advanced)
					if(heal_brute_final > 0)
						if(SEND_SIGNAL(affecting, COMSIG_LIMB_ADD_SUTURES, TRUE, FALSE, heal_brute_final * 0.5))
							heal_brute_final *= 0.75
					if(heal_burn_final > 0)
						if(SEND_SIGNAL(affecting, COMSIG_LIMB_ADD_SUTURES, FALSE, TRUE, heal_burn_final * 0.5))
							heal_burn_final *= 0.75

				if(heal_brute_final > 0 || heal_burn_final > 0)
					affecting.heal_damage(brute = heal_brute_final, burn = heal_burn_final)

				use(1)
				if(success_sound)
					playsound(user, success_sound, 25, 1, 2)
				return TRUE

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "medical gauze"
	desc = "Some sterile gauze to wrap around bloody stumps and lacerations."
	icon_state = "brutepack"
	item_state_slots = list(WEAR_AS_GARB = "brutepack (bandages)")
	heal_brute = 4 // apparently gauzes never had a heal_brute modifier for the longest time, gee
	stack_id = "bruise pack"

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/person as mob, mob/user as mob)
	if(..())
		return TRUE

	var/mob/living/carbon/human/treating = person
	var/obj/limb/affecting = treating.get_limb(user.zone_selected)

	if(pack_arterial_bleeding(user, treating, affecting))
		return

	apply_treatment(treating, user, affecting, "bandaging", heal_brute, 0, FALSE, 'sound/handling/bandage.ogg',
		SPAN_HELPFUL("<b>bandage</b>"),
		SPAN_WARNING("There are no wounds on"),
		SPAN_WARNING("The wounds on"))

/obj/item/stack/medical/bruise_pack/two
	amount = 2

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat burns, infected wounds, and relieve itching in unusual places."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	item_state_slots = list(WEAR_AS_GARB = "ointment")
	heal_burn = 4
	stack_id = "ointment"

/obj/item/stack/medical/ointment/attack(mob/living/carbon/person as mob, mob/user as mob)
	if(..())
		return TRUE

	var/mob/living/carbon/human/treating = person
	var/obj/limb/affecting = treating.get_limb(user.zone_selected)

	apply_treatment(treating, user, affecting, "salving", 0, heal_burn, FALSE, 'sound/handling/ointment_spreading.ogg',
		SPAN_HELPFUL("<b>salve the burns</b> on"),
		SPAN_WARNING("There are no burns on"),
		SPAN_WARNING("The burns on"))

/obj/item/stack/medical/advanced/bruise_pack
	name = "trauma kit"
	singular_name = "trauma kit"
	desc = "A trauma kit for severe injuries."
	icon_state = "traumakit"
	item_state = "brutekit"
	heal_brute = 8

	stack_id = "advanced bruise pack"

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/person as mob, mob/user as mob)
	if(..())
		return TRUE

	var/mob/living/carbon/human/treating = person
	var/obj/limb/affecting = treating.get_limb(user.zone_selected)

	if(pack_arterial_bleeding(user, treating, affecting))
		return

	apply_treatment(treating, user, affecting, "bandaging", heal_brute, 0, TRUE, 'sound/handling/bandage.ogg',
		SPAN_HELPFUL("<b>clean and seal</b> the wounds on"),
		SPAN_WARNING("There are no wounds on"),
		SPAN_WARNING("The wounds on"))

/obj/item/stack/medical/advanced/bruise_pack/upgraded
	name = "upgraded trauma kit"
	singular_name = "upgraded trauma kit"
	stack_id = "upgraded trauma kit"

	icon_state = "traumakit_upgraded"
	desc = "An upgraded trauma treatment kit. Three times as effective as standard-issue, and non-replenishable. Use sparingly on only the most critical wounds."

	max_amount = 10
	amount = 10

/obj/item/stack/medical/advanced/bruise_pack/upgraded/Initialize(mapload, ...)
	. = ..()
	heal_brute = initial(heal_brute) * 2 // 2x stronger

/obj/item/stack/medical/advanced/bruise_pack/predator
	name = "mending herbs"
	singular_name = "mending herb"
	desc = "A poultice made of soft leaves that is rubbed on bruises."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "brute_herbs"
	item_state = "brute_herbs"
	heal_brute = 12
	stack_id = "mending herbs"
	alien = TRUE

/obj/item/stack/medical/advanced/ointment
	name = "burn kit"
	singular_name = "burn kit"
	desc = "A treatment kit for severe burns."
	icon_state = "burnkit"
	item_state = "burnkit"
	heal_burn = 8

	stack_id = "burn kit"

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/person as mob, mob/user as mob)
	if(..())
		return TRUE

	var/mob/living/carbon/human/treating = person
	var/obj/limb/affecting = treating.get_limb(user.zone_selected)

	apply_treatment(treating, user, affecting, "salving", 0, heal_burn, TRUE, 'sound/handling/ointment_spreading.ogg',
		SPAN_HELPFUL("<b>cover the burns</b> on"),
		SPAN_WARNING("There are no burns on"),
		SPAN_WARNING("The burns on"))

/obj/item/stack/medical/advanced/ointment/upgraded
	name = "upgraded burn kit"
	singular_name = "upgraded burn kit"
	stack_id = "upgraded burn kit"

	icon_state = "burnkit_upgraded"
	desc = "An upgraded burn treatment kit. Three times as effective as standard-issue, and non-replenishable. Use sparingly on only the most critical burns."

	max_amount = 10
	amount = 10

/obj/item/stack/medical/advanced/ointment/upgraded/Initialize(mapload, ...)
	. = ..()
	heal_burn = initial(heal_burn) * 2 // 2x stronger

/obj/item/stack/medical/advanced/ointment/predator
	name = "soothing herbs"
	singular_name = "soothing herb"
	desc = "A poultice made of cold, blue petals that is rubbed on burns."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "burn_herbs"
	item_state = "burn_herbs"
	heal_burn = 12
	stack_id = "soothing herbs"
	alien = TRUE

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	desc = "A collection of different splints and securing gauze. What, did you think we only broke legs out here?"
	icon_state = "splint"
	item_state = "splint"
	amount = 5
	max_amount = 5
	stack_id = "splint"

	var/indestructible_splints = FALSE

/obj/item/stack/medical/splint/Initialize(mapload, amount)
	. = ..()
	if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/indestructible_splints))
		icon_state = "nanosplint"
		indestructible_splints = TRUE
		update_icon()

/obj/item/stack/medical/splint/attack(mob/living/carbon/person, mob/user)
	if(..())
		return TRUE

	if(user.action_busy)
		return

	if(ishuman(person))
		var/mob/living/carbon/human/treating = person
		var/obj/limb/affecting = treating.get_limb(user.zone_selected)
		var/limb = affecting.display_name

		if(!(affecting.name in list("l_arm", "r_arm", "l_leg", "r_leg", "r_hand", "l_hand", "r_foot", "l_foot", "chest", "groin", "head")))
			to_chat(user, SPAN_WARNING("You can't apply a splint there!"))
			return

		if(affecting.status & LIMB_DESTROYED)
			var/message = SPAN_WARNING("[user == person ? "You don't" : "[person] doesn't"] have \a [limb]!")
			to_chat(user, message)
			return

		if(affecting.status & LIMB_SPLINTED)
			var/message = "[user == person ? "Your" : "[person]'s"]"
			to_chat(user, SPAN_WARNING("[message] [limb] is already splinted!"))
			return

		if(person != user)
			var/possessive = "[user == person ? "your" : "\the [person]'s"]"
			var/possessive_their = "[user == person ? user.p_their() : "\the [person]'s"]"
			user.affected_message(person,
				SPAN_HELPFUL("You <b>start splinting</b> [possessive] <b>[affecting.display_name]</b>."),
				SPAN_HELPFUL("[user] <b>starts splinting</b> your <b>[affecting.display_name]</b>."),
				SPAN_NOTICE("[user] starts splinting [possessive_their] [affecting.display_name]."))
		else
			if((!user.hand && (affecting.name in list("r_arm", "r_hand"))) || (user.hand && (affecting.name in list("l_arm", "l_hand"))))
				to_chat(user, SPAN_WARNING("You can't apply a splint to the \
					[affecting.name == "r_hand"||affecting.name == "l_hand" ? "hand":"arm"] you're using!"))
				return
			// Self-splinting
			user.affected_message(person,
				SPAN_HELPFUL("You <b>start splinting</b> your <b>[affecting.display_name]</b>."),
				,
				SPAN_NOTICE("[user] starts splinting \his [affecting.display_name]."))

		if(affecting.apply_splints(src, user, person, indestructible_splints)) // Referenced in external organ helpers.
			use(1)
			playsound(user, 'sound/handling/splint1.ogg', 25, 1, 2)

/obj/item/stack/medical/splint/nano
	name = "nano splints"
	singular_name = "nano splint"

	icon_state = "nanosplint"
	desc = "Advanced technology allows these splints to hold bones in place while being flexible and damage-resistant. These aren't plentiful, so use them sparingly on critical areas."

	indestructible_splints = TRUE
	amount = 5
	max_amount = 5

	stack_id = "nano splint"

/obj/item/stack/medical/splint/nano/research
	desc = "Advanced technology allows these splints to hold bones in place while being flexible and damage-resistant. Those are made from durable carbon fiber and dont look cheap, better use them sparingly."

/obj/item/stack/medical/tourniquet
	name = "medical tourniquets"
	singular_name = "medical tourniquet"
	desc = "A collection of tourniquets of various colours. Whatever you do, do NOT apply to your neck."
	icon_state = "nanosplint" //"tourniquet"
	item_state = "nanosplint" //"tourniquet"
	amount = 3
	max_amount = 3
	stack_id = "tourniquet"

/obj/item/stack/medical/tourniquet/attack(mob/living/carbon/person, mob/user)
	if(..())
		return TRUE

	if(user.action_busy)
		return

	if(ishuman(person))
		var/mob/living/carbon/human/treating = person
		var/obj/limb/affecting = treating.get_limb(user.zone_selected)
		tighten_limb(user, treating, affecting)

/obj/item/stack/medical/proc/tighten_limb(mob/user, mob/living/carbon/human/person, obj/limb/affecting, duration) // dreaded copy paste from splints

	if(ishuman(person)) // make things easier for us, love qol
		if(affecting.name == "l_hand")
			affecting = person.get_limb("l_arm")
		else if(affecting.name == "r_hand")
			affecting = person.get_limb("r_arm")

		if(affecting.name == "l_foot")
			affecting = person.get_limb("l_leg")
		else if(affecting.name == "r_foot")
			affecting = person.get_limb("r_leg")


		var/limb = affecting.display_name

		if(!(affecting.name in list("l_arm", "r_arm", "l_leg", "r_leg", "head"))) // check Abdominal aortic tourniquet on google about chest/groin tourniquets
			to_chat(user, SPAN_WARNING("You can't apply a [src] there!"))
			return

		if(affecting.status & LIMB_DESTROYED)
			var/message = SPAN_WARNING("[user == person ? "You don't" : "[person] doesn't"] have \a [limb]!")
			to_chat(user, message)
			return

		if(affecting.status & LIMB_CONSTRICTED)
			var/message = "[user == person ? "Your" : "[person]'s"]"
			to_chat(user, SPAN_WARNING("[message] [limb] is already constricted!"))
			return

		if(person != user)
			var/possessive = "[user == person ? "your" : "\the [person]'s"]"
			var/possessive_their = "[user == person ? user.p_their() : "\the [person]'s"]"
			user.affected_message(person,
				SPAN_HELPFUL("You <b>start tightening the [src] on</b> [possessive] <b>[affecting.display_name]</b>."),
				SPAN_HELPFUL("[user] <b>starts tightening</b> your <b>[affecting.display_name]</b> with the <b>[src]</b>."),
				SPAN_NOTICE("[user] starts tightening the [src] on [possessive_their] [affecting.display_name]."))
		else
			if((!user.hand && (affecting.name in list("r_arm", "r_hand"))) || (user.hand && (affecting.name in list("l_arm", "l_hand"))))
				to_chat(user, SPAN_WARNING("You can't apply a tourniquet to the \
					[affecting.name == "r_hand"||affecting.name == "l_hand" ? "hand":"arm"] you're using!"))
				return

			// self application
			user.affected_message(person,
				SPAN_HELPFUL("You <b>start tightening</b> your <b>[affecting.display_name]</b> with \the <b>[src]</b>."),
				,
				SPAN_NOTICE("[user] starts tightening \his [affecting.display_name] with \the [src]."))

		if(affecting.apply_tourniquet(src, user, person)) // limbs.dm
			use(1)
			playsound(user, 'sound/handling/splint1.ogg', 25, 1, 2)

/obj/item/stack/medical/proc/pack_arterial_bleeding(mob/user, mob/living/carbon/human/person, obj/limb/affecting, duration)
	for(var/datum/effects/bleeding/arterial/art_bleed in affecting.bleeding_effects_list)
		var/time_to_take
		var/do_after_result


		if(person == user)
			user.visible_message(SPAN_WARNING("[user] fumbles with [src]..."), SPAN_WARNING("You fumble with [src]..."))
			time_to_take += 8 SECONDS
			if(affecting.name in list("l_leg", "r_leg", "r_foot", "l_foot"))
				do_after_result = do_after(user, time_to_take * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, person, INTERRUPT_MOVED, BUSY_ICON_MEDICAL, status_effect = SUPERSLOW)
			else
				do_after_result = do_after(user, time_to_take * user.get_skill_duration_multiplier(SKILL_MEDICAL), (INTERRUPT_NO_NEEDHAND & (~INTERRUPT_MOVED)), BUSY_ICON_FRIENDLY, person, (INTERRUPT_NONE & (~INTERRUPT_MOVED)), BUSY_ICON_MEDICAL, status_effect = SLOW)
		else
			time_to_take += 5 SECONDS
			user.visible_message(SPAN_WARNING("[user] fumbles with \the [src], wrapping it around [person]..."), SPAN_WARNING("You fumble with \the [src], wrapping it around [person]..."))
			do_after_result = do_after(user, time_to_take * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, person, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)

		if(user.skills && skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
			time_to_take -= user.skills.get_skill_level(SKILL_MEDICAL)

		if(do_after_result)
			var/possessive = "[user == person ? "your" : "the [person]'s"]"
			var/possessive_their = "[user == person ? person.p_their() : "the [person]'s"]"

			var/internal_bleed_chance = 50
			if(user.skills)
				switch(user.skills.get_skill_level(SKILL_MEDICAL))
					if(SKILL_MEDICAL_MASTER)
						internal_bleed_chance = 5
					if(SKILL_MEDICAL_DOCTOR)
						internal_bleed_chance = 15
					if(SKILL_MEDICAL_MEDIC)
						internal_bleed_chance = 25
					if(SKILL_MEDICAL_TRAINED)
						internal_bleed_chance = 35

			var/message_end = "<b>stopping the bleeding.</b>"
			if(prob(internal_bleed_chance))
				affecting.add_bleeding(null, internal = TRUE)
				message_end = SPAN_RED("<b>but you may have caused internal bleeding in the process!</b>")

			user.affected_message(person,
			SPAN_HELPFUL("You <b>pack</b> the damaged artery in [possessive] <b>[affecting.display_name]</b>, [message_end]"),
			SPAN_HELPFUL("[user] <b>packs</b> the damaged artery in your  <b>[affecting.display_name]</b>, [message_end]"),
			SPAN_NOTICE("[user] packs the damaged artery in [possessive_their] [affecting.display_name], [message_end]"))
			qdel(art_bleed)
			use(1)
			// decor :)
			var/obj/item/prop/colony/usedbandage/bloody_bandage = new /obj/item/prop/colony/usedbandage(person.loc)
			bloody_bandage.dir = pick(1, 4, 5, 6, 9, 10)
			bloody_bandage.pixel_x = pick(rand(8,18), rand(-8,-18))
			bloody_bandage.pixel_y = pick(rand(8, 18), rand(-8,-18))
			bloody_bandage.garbage = TRUE // dont want to clutter the colony with like thousands of these

			return TRUE

	return FALSE
