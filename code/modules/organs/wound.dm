
/*
					WOUNDS
*/
/datum/wound
	// number representing the current stage
	var/current_stage = 0

	// description of the wound
	var/desc = "wound" //default in case something borks

	// amount of damage this wound causes
	var/damage = 0
	// amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/min_damage = 0

	// is the wound bandaged/sutured?
	var/bandaged = NONE
	// is the wound salved/grafted?
	var/salved = NONE
	var/created = 0
	// number of wounds of this type
	var/amount = 1

	/*  These are defined by the wound type and should not be changed */

	// stages such as "cut", "deep cut", etc.
	var/list/stages
	// internal wounds can only be fixed through surgery
	var/internal = 0
	// one of CUT, BRUISE, BURN, or PIERCE
	var/damage_type = CUT
	// whether this wound needs a bandage/salve to heal at all
	// the maximum amount of damage that this wound can have and still naturally regenerate
	var/regeneration_cutoff = 0 //default, 0 basically the wound cant regenerate

	var/icon/bandaged_icon = null // Icon for gauze over a wound

	// helper lists
	var/tmp/list/desc_list = list()
	var/tmp/list/damage_list = list()

/datum/wound/New(damage)
	created = world.time

	// reading from a list("stage" = damage) is pretty difficult, so build two separate
	// lists from them instead
	for(var/V in stages)
		desc_list += V
		damage_list += stages[V]

	src.damage = damage

	// initialize with the appropriate stage
	src.init_stage(damage)

// returns 1 if there's a next stage, 0 otherwise
/datum/wound/proc/init_stage(initial_damage)
	current_stage = length(stages)

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= initial_damage / src.amount)
		src.current_stage--

	src.min_damage = damage_list[current_stage]
	src.desc = desc_list[current_stage]

// the amount of damage per wound
/datum/wound/proc/wound_damage()
	return src.damage / src.amount

/datum/wound/proc/can_regenerate()
	if(src.wound_damage() <= regeneration_cutoff)
		return 1

	return is_treated()

// checks whether the wound has been appropriately treated
/datum/wound/proc/is_treated()
	if(damage_type == BRUISE || damage_type == CUT)
		return bandaged
	else if(damage_type == BURN)
		return salved

// Checks whether other other can be merged into src.
/datum/wound/proc/can_merge(datum/wound/other)
	if (other.type != src.type) return 0
	if (other.current_stage != src.current_stage) return 0
	if (other.damage_type != src.damage_type) return 0
	if (!(other.can_regenerate()) != !(src.can_regenerate())) return 0
	if (!(other.bandaged) != !(src.bandaged)) return 0
	if (!(other.salved) != !(src.salved)) return 0
	return 1

/datum/wound/proc/merge_wound(datum/wound/other)
	src.damage += other.damage
	src.amount += other.amount
	src.created = max(src.created, other.created) //take the newer created time

// heal the given amount of damage, and if the given amount of damage was more
// than what needed to be healed, return how much heal was left
// set @heals_internal to also heal internal organ damage
/datum/wound/proc/heal_damage(amount, heals_internal = 0)
	if(src.internal && !heals_internal)
		// heal nothing
		return amount

	var/healed_damage = min(src.damage, amount)
	amount -= healed_damage
	src.damage -= healed_damage

	while(src.wound_damage() < damage_list[current_stage] && current_stage < length(src.desc_list))
		current_stage++
	desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

	// return amount of healing still leftover, can be used for other wounds
	return amount

// opens the wound again
/datum/wound/proc/open_wound(damage)
	src.damage += damage
	bandaged = NONE
	salved = NONE

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= src.damage / src.amount)
		src.current_stage--

	src.desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

// returns whether this wound can absorb the given amount of damage.
// this will prevent large amounts of damage being trapped in less severe wound types
/datum/wound/proc/can_worsen(damage_type, damage)
	if (src.damage_type != damage_type)
		return 0 //incompatible damage types

	if (src.amount > 1)
		return 0

	//with 1.5*, a shallow cut will be able to carry at most 30 damage,
	//37.5 for a deep cut
	//52.5 for a flesh wound, etc.
	var/max_wound_damage = 1.5*src.damage_list[1]
	if (src.damage + damage > max_wound_damage)
		return 0

	return 1

/* WOUND DEFINITIONS **/

//Note that the MINIMUM damage before a wound can be applied should correspond to
//the damage amount for the stage with the same name as the wound.
//e.g. /datum/wound/cut/deep should only be applied for 15 damage and up,
//because in it's stages list, "deep cut" = 15.

// 2025 note, the above isnt exactly necessary anymore, since existing wounds can worsen - nihi
/proc/get_wound_type(type = CUT, damage)
	switch(type)
		if(CUT)
			switch(damage)
				if(70 to INFINITY)
					return /datum/wound/cut/massive
				if(50 to 70)
					return /datum/wound/cut/deep
				if(15 to 25)
					return /datum/wound/cut/large
				if(0 to 10)
					return /datum/wound/cut/small

		if(PIERCE)
			switch(damage)
				if(50 to INFINITY)
					return /datum/wound/pierce/perforating
				if(35 to 50)
					return /datum/wound/pierce/gaping
				if(15 to 35)
					return /datum/wound/pierce/deep
				if(0 to 10)
					return /datum/wound/pierce/shallow
		if(BRUISE)
			switch(damage)
				if(50 to INFINITY)
					return /datum/wound/pierce/perforating
				if(35 to 50)
					return /datum/wound/pierce/gaping
				if(15 to 35)
					return /datum/wound/pierce/deep
				if(0 to 10)
					return /datum/wound/pierce/shallow

		if(BURN)
			switch(damage)
				if(50 to INFINITY)
					return /datum/wound/burn/carbonised
				if(35 to 50)
					return /datum/wound/burn/heavy
				if(10 to 35)
					return /datum/wound/burn/thick
				if(0 to 10)
					return /datum/wound/burn/light
	return null //no wound

/* CUTS **/
/datum/wound/cut/small
	// link wound descriptions to amounts of damage
	stages = list("ugly ripped cut" = 20, "ripped cut" = 15, "cut" = 10, "healing cut" = 5, "small scab" = 0)
	damage_type = CUT
	regeneration_cutoff = 20

/datum/wound/cut/large
	stages = list("ugly ripped flesh wound" = 35, "ugly flesh wound" = 30, "flesh wound" = 25, "deep cut" = 15, "clotted cut" = 10, "scab" = 5, "fresh skin" = 0)
	damage_type = CUT
	regeneration_cutoff = 15

/datum/wound/cut/deep
	stages = list("big gaping wound" = 60, "gaping wound" = 50, "large blood soaked clot" = 25, "large clot" = 15, "large angry scar" = 10, "large straight scar" = 0)
	damage_type = CUT
	regeneration_cutoff = 5

/datum/wound/cut/massive
	stages = list("massive wound" = 70, "massive healing wound" = 50, "healing gaping wound" = 25, "massive angry scar" = 10,  "massive jagged scar" = 0)
	damage_type = CUT

/* PIERCES **/
/datum/wound/pierce/shallow
	stages = list("nasty puncture" = 15, "puncture" = 10, "small hole" = 5, "healing hole" = 2, "small scab" = 0)
	damage_type = PIERCE
	regeneration_cutoff = 15

/datum/wound/pierce/deep
	stages = list("deep puncture" = 35, "bleeding hole" = 25, "hole" = 15, "clotted hole" = 10, "scab" = 5, "fresh skin" = 0)
	damage_type = PIERCE
	regeneration_cutoff = 10

/datum/wound/pierce/gaping
	stages = list("large bleeding hole" = 50, "large hole" = 35, "large clotted hole" = 20, "large scab" = 10, "scar" = 0)
	damage_type = PIERCE
	regeneration_cutoff = 5

/datum/wound/pierce/perforating
	stages = list("gaping hole" = 70, "large bleeding hole" = 50, "large clotted hole" = 25, "massive angry scar" = 10, "massive jagged scar" = 0)
	damage_type = PIERCE


/* BRUISES... and also avulsion and contusion **/
/datum/wound/bruise/superficial
	stages = list("monumental bruise" = 80, "huge bruise" = 50, "large bruise" = 30,\
				  "moderate bruise" = 20, "small bruise" = 10, "tiny bruise" = 5)
	regeneration_cutoff = 30
	damage_type = BRUISE

/datum/wound/bruise/contusion

/datum/wound/bruise/avulsion // tissue loss + internal damage enough to cause hematomas etc

/* BURNS **/
/datum/wound/burn/light
	stages = list("ripped burn" = 10, "moderate burn" = 5, "healing moderate burn" = 2, "fresh skin" = 0)
	damage_type = BURN
	regeneration_cutoff = 10

/datum/wound/burn/thick
	stages = list("severe burn" = 30, "large burn" = 15, "healing severe burn" = 10, "healing large burn" = 5, "burn scar" = 0)
	damage_type = BURN
	regeneration_cutoff = 5

/datum/wound/burn/heavy
	stages = list("ripped deep burn" = 45, "deep burn" = 40, "healing deep burn" = 15,  "large burn scar" = 0)
	damage_type = BURN

/datum/wound/burn/carbonised
	stages = list("carbonised area" = 50, "healing carbonised area" = 20, "massive burn scar" = 0)
	damage_type = BURN

/* INTERNAL BLEEDING **/
/datum/wound/internal_bleeding
	internal = 1
	stages = list("bruised artery" = 0)

/* INTERNAL BLEEDING **/
/datum/wound/arterial_bleeding
	stages = list("ruptured artery" = 0)

/* EXTERNAL ORGAN LOSS **/
/datum/wound/lost_limb
	damage_type = CUT
	stages = list("ripped stump" = 65, "bloody stump" = 50, "clotted stump" = 25, "scarred stump" = 0)

/datum/wound/lost_limb/can_merge(datum/wound/other)
	return 0 //cannot be merged

/datum/wound/lost_limb/small
	stages = list("ripped stump" = 40, "bloody stump" = 30, "clotted stump" = 15, "scarred stump" = 0)
