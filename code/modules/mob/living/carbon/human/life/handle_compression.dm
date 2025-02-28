//pain_human.dm call

/mob/living/var/compressed = 0

/mob/living/proc/adjust_compression()
    not_compressed = if(LIMB_COMPRESSED) < 1
	compressed = if(LIMB_COMPRESSED) + 1

	if(compressed =+ 1)
		COMPRESSING
	return

/mob/living/proc/handle_compression()
    ...
    adjust_compression(-1)
