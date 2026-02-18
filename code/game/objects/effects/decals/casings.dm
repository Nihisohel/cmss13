/*
Generated per the various mags, and then changed based on the number of
casings. .dir is the main thing that controls the icon. It modifies
the icon_state to look like more casings are hitting the ground.
There are 8 directions, 8 bullets are possible so after that it tries to grab the next
icon_state while reseting the direction. After 16 casings, it just ignores new
ones. At that point there are too many anyway. Shells and bullets leave different
items, so they do not intersect. This is far more efficient than using Bl*nd() or
Turn() or Shift() as there is virtually no overhead. ~N
*/

/* do note that the above comments are outdated and are just kept for record,
and that most of the ejection procedures utilize image matrices for randomization
that said, the icon_states in the dmi files aren't culled for use by mappers - nihi
*/

/obj/effect/decal/cleanable/ammo_casing
	name = "spent casing"
	desc = "Empty and useless now."
	icon = 'icons/obj/items/weapons/casings.dmi'
	icon_state = "casing"
	appearance_flags = PIXEL_SCALE
	layer = ABOVE_WEED_LAYER
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/ejection_sfx = "gun_casing_generic"
	/// number of variations of the casing found in its dmi file, much cleaner than spawning multiple casings on 1 tile for mappers
	var/number_of_states = 10
	/// true by default, responsible for randomizing the casing on mapload, for mappers.
	var/randomized_mapload = TRUE

/obj/effect/decal/cleanable/ammo_casing/Initialize(mapload)

	if(randomized_mapload)
		if(mapload && number_of_states) // pretty much only called on map init and stuff
			icon_state += "_[rand(1,number_of_states)]" // the casing dmi file needs to be slightly overhauled, its dirty, and doesnt use all the old system jank with its icon_state manipulation, but at least it works out of the box

	setDir(pick(GLOB.alldirs))

	overlayed_image = image(icon, icon_state)
	overlayed_image.appearance_flags = PIXEL_SCALE
	overlayed_image.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	overlayed_image.layer = ABOVE_WEED_LAYER

	. = ..()

/obj/effect/decal/cleanable/ammo_casing/cartridge
	name = "spent cartridge"
	icon_state = "cartridge"

/obj/effect/decal/cleanable/ammo_casing/shell
	name = "spent shell"
	icon_state = "generic_shell" //its kinda like darker red, but more vague red if you know what i mean??
	ejection_sfx = "gun_casing_shotgun"

/obj/effect/decal/cleanable/ammo_casing/shell/green_shell
	name = "spent shell"
	icon_state = "green_shell"

/obj/effect/decal/cleanable/ammo_casing/shell/red_shell
	name = "spent shell"
	icon_state = "red_shell"
	number_of_states = 0

/obj/effect/decal/cleanable/ammo_casing/shell/blue_shell
	name = "spent shell"
	icon_state = "blue_shell"

/obj/effect/decal/cleanable/ammo_casing/shell/purple_shell
	name = "spent shell"
	icon_state = "purple_shell"
	number_of_states = 0

/obj/effect/decal/cleanable/ammo_casing/shell/incen_shell
	name = "spent shell"
	icon_state = "incen_shell"
	number_of_states = 0

/obj/effect/decal/cleanable/ammo_casing/shell/blank_shell
	name = "spent shell"
	icon_state = "blank_shell"
	number_of_states = 0

/obj/effect/decal/cleanable/ammo_casing/shell/twobore_shell
	name = "comedically sized spent shell"
	icon_state = "twobore_shell"
	number_of_states = 0
