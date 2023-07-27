
/*Access levels. Changed into defines, since that's what they should be.
It's best not to mess with the numbers of the regular access levels because
most of them are tied into map-placed objects. This should be reworked in the future.*/
//WE NEED TO REWORK THIS ONE DAY.  Access levels make me cry - Apophis
#define ACCESS_MARINE_SENIOR 1
#define ACCESS_MARINE_DATABASE 2
#define ACCESS_MARINE_BRIG 3
#define ACCESS_MARINE_ARMORY 4
#define ACCESS_MARINE_CMO 5
#define ACCESS_MARINE_CE 6
#define ACCESS_MARINE_ENGINEERING 7
#define ACCESS_MARINE_MEDBAY 8
#define ACCESS_MARINE_PREP 9
#define ACCESS_MARINE_MEDPREP 10
#define ACCESS_MARINE_ENGPREP 11
#define ACCESS_MARINE_LEADER 12
#define ACCESS_MARINE_SPECPREP 13
#define ACCESS_MARINE_SMARTPREP 14

#define ACCESS_MARINE_ALPHA 15
#define ACCESS_MARINE_BRAVO 16
#define ACCESS_MARINE_CHARLIE 17
#define ACCESS_MARINE_DELTA 18

#define ACCESS_MARINE_COMMAND 19
#define ACCESS_MARINE_CHEMISTRY 20
#define ACCESS_MARINE_CARGO 21
#define ACCESS_MARINE_DROPSHIP 22
#define ACCESS_MARINE_PILOT 23
#define ACCESS_MARINE_CMP 24
#define ACCESS_MARINE_MORGUE 25
#define ACCESS_MARINE_RO 26
#define ACCESS_MARINE_CREWMAN    27
#define ACCESS_MARINE_RESEARCH 28
#define ACCESS_MARINE_SEA    29
#define ACCESS_MARINE_KITCHEN    30
#define ACCESS_MARINE_CO 31
#define ACCESS_MARINE_TL_PREP 32

#define ACCESS_MARINE_MAINT 34
#define ACCESS_MARINE_OT 35

#define ACCESS_MARINE_SYNTH 36

// AI Core Accesses
/// Used in temporary passes
#define ACCESS_MARINE_AI_TEMP 90
/// Used as dedicated access to ARES Core.
#define ACCESS_MARINE_AI 91
/// Used to access Maintenance Protocols on ARES Interface.
#define ACCESS_ARES_DEBUG 92

//Surface access levels
#define ACCESS_CIVILIAN_PUBLIC 100
#define ACCESS_CIVILIAN_LOGISTICS 101
#define ACCESS_CIVILIAN_ENGINEERING 102
#define ACCESS_CIVILIAN_RESEARCH 103
#define ACCESS_CIVILIAN_BRIG 104
#define ACCESS_CIVILIAN_MEDBAY 105
#define ACCESS_CIVILIAN_COMMAND 106

//Special access levels. Should be alright to modify these.
#define ACCESS_WY_PMC_GREEN 180
#define ACCESS_WY_PMC_ORANGE 181
#define ACCESS_WY_PMC_RED 182
#define ACCESS_WY_PMC_BLACK 183
#define ACCESS_WY_PMC_WHITE 184
#define ACCESS_WY_CORPORATE 200
#define ACCESS_ILLEGAL_PIRATE 201
#define ACCESS_WY_CORPORATE_DS 202
#define ACCESS_PRESS 203
//=================================================

// Yautja Access Levels
/// Requires a visible ID chip to open
#define ACCESS_YAUTJA_SECURE 250
/// Elders+ only
#define ACCESS_YAUTJA_ELDER 251
/// Ancients only
#define ACCESS_YAUTJA_ANCIENT 252