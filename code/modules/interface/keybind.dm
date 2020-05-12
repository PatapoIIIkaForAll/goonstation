/**
 * This file is intended to hold all data pertaining to keybind_style datums and related functionality
 */

///Global list holding all of the keybind style datums - Intitalized in World preload.
var/global/list/datum/keybind_style/keybind_styles = null

///Global list holding keybind style datums that we needed to instantiate - lazy
var/global/list/datum/keybind_style/instantiated_styles = null

//The data you get from get_keybind... will be merged with existing keybind datum on the client in layers
//base -> base_wasd -> human -> human_wasd for example
//If you switch to a different mobtype, such as a robot, you would reset the keymap, and successive calls of build_keymap will apply_keybind

///List on each client containing the styles we've applied so we don't double-apply.
/client/var/list/applied_keybind_styles = list()


/** get_keybind_style_datum: Given the string name of a style, finds the keybind_style with the matching name.
 *	Internal use only.
 *	Called by apply_keybind to fetch our datum.
 */
/client/proc/get_keybind_style_datum(style_name)
	PROTECTED_PROC(TRUE)

	if (!keybind_styles)
		keybind_styles = typesof(/datum/keybind_style)

	for (var/found in keybind_styles)
		var/datum/keybind_style/found_style = found
		if (initial(found_style.name) == style_name)
			boutput("[found_style]")
			return found_style
	logTheThing("debug", null, null, "<B>ZeWaka/Keybinds:</B> No keybind style found with the name [style_name].")

/** apply_keys: Takes a keybind_style to apply to the src client
 *	Internal use only.
 *	Merges the given keybind_style onto the client. Also adds it to the client's tracking list.
 */
/client/proc/apply_keys(datum/keybind_style/style)
	PROTECTED_PROC(TRUE)

	if (applied_keybind_styles.Find(initial(style.name)))
		logTheThing("debug", null, null, "<B>ZeWaka/Keybinds:</B> Attempted to apply [initial(style.name)] to [src] when already present.")
		return
	src.applied_keybind_styles.Add(initial(style.name))
	var/datum/keybind_style/init_style = new style //Can't do static referencing for merge, press F to pay respekts
	var/datum/keymap/init_keymap = new /datum/keymap(init_style.changed_keys)
	src.keymap.merge(init_keymap)

/** unapply_keys: Takes a keybind_style to remove from the src client
 *  Internal use only.
 *  De-merges the given keybind_style onto the client. Also removes it from the client's tracking list.
 */
/client/proc/unapply_keys(datum/keybind_style/style)
	PROTECTED_PROC(TRUE)

	if (!applied_keybind_styles.Find(initial(style.name)))
		logTheThing("debug", null, null, "<B>ZeWaka/Keybinds:</B> Attempted to unapply [initial(style.name)] to [src] when not on them.")
		return

	src.applied_keybind_styles.Remove(initial(style.name))
	///////////////////////////////////////////////////////TODO: REMOVING LOGIC + DEMERGE PROC ON KEYMAPS

/** apply_keybind: Takes a given string style, and finds the datum, then applies it.
 *	External use only.
 *	This is what external stuff should be calling when applying their additive styles.
 */
/client/proc/apply_keybind(style_str)
	apply_keys(get_keybind_style_datum(style_str))

/** unapply_keybind: Takes a given string style, and finds the datum, then unapplies it.
 *  External use only.
 *  This is what external stuff should be calling when wanting to remove an additive style.
 */
/client/proc/unapply_keybind(style_str)
	unapply_keys(get_keybind_style_datum(style_str))



/// Keybinds are sub-sorted in order of most common, since then it'll be further up the global list of styles. Micro-optimizations whoo!

///
///	BASE MOB KEYBINDS
///

/datum/keybind_style
	var/name = "base"
	var/changed_keys = list(
	"W" = KEY_FORWARD,
	"A" = KEY_LEFT,
	"S" = KEY_BACKWARD,
	"D" = KEY_RIGHT,
	"B" = KEY_POINT,
	"T" = "say",
	"Y" = "say_radio",
	"ALT+W" = "whisper",
	"ALT+C" = "ooc",
	"ALT+L" = "looc",
	"ALT+T" = "dsay",
	"CTRL+T" = "asay",
	"F" = "fart",
	"R" = "flip",
	"CTRL+A" = "salute",
	"CTRL+B" = "burp",
	"CTRL+D" = "dance",
	"CTRL+E" = "eyebrow",
	"CTRL+F" = "fart",
	"CTRL+G" = "gasp",
	"CTRL+H" = "raisehand",
	"CTRL+L" = "laugh",
	"CTRL+N" = "nod",
	"CTRL+Q" = "wave",
	"CTRL+R" = "flip",
	"CTRL+S" = "scream",
	"CTRL+W" = "wink",
	"CTRL+X" = "flex",
	"CTRL+Y" = "yawn",
	"CTRL+Z" = "snap",
	"I" = "look_n",
	"K" = "look_s",
	"J" = "look_w",
	"L" = "look_e",
	"P" = "pickup",
	"F1" = "adminhelp",
	"F3" = "mentorhelp",
	"CTRL+P" = "togglepoint",
	"F2" = "autoscreenshot",
	"SHIFT+F2" = "screenshot",
	"G" = "refocus",
	"ESCAPE" = "mainfocus",
	"RETURN" = "mainfocus",
	"`" = "admin_interact",
	"~" = "admin_interact"
	)

/datum/keybind_style/arrow
	name = "base_arrow"
	changed_keys = list(
		"NORTH" = KEY_FORWARD,
		"SOUTH" = KEY_BACKWARD,
		"WEST" = KEY_LEFT,
		"EAST" = KEY_RIGHT,
	)

/datum/keybind_style/tg
	name = "base_tg"
	changed_keys = list(
		"DELETE" = "stop_pull"
	)

/datum/keybind_style/azerty
	name = "base_azerty"
	changed_keys = list(
		"Z" = KEY_FORWARD,
		"S" = KEY_BACKWARD,
		"Q" = KEY_LEFT,
		"D" = KEY_RIGHT
	)

///
///	HUMAN-SPECIFIC KEYBINDS
///

/datum/keybind_style/human
	name = "human"
	changed_keys = list(
		"SHIFT" = KEY_RUN,
		"CTRL" = KEY_PULL,
		"ALT" = KEY_EXAMINE,
		"SPACE" = KEY_THROW,
		"1" = "help",
		"2" = "disarm",
		"3" = "grab",
		"4" = "harm",
		"5" = "head",
		"6" = "chest",
		"7" = "l_arm",
		"8" = "r_arm",
		"9" = "l_leg",
		"0" = "r_leg",
		"-" = "walk",
		"=" = "rest",
		"V" = "equip",
		"Q" = "drop",
		"E" = "swaphand",
		"C" = "attackself",
		"DELETE" = "togglethrow"
	)

/datum/keybind_style/human/arrow
	name = "human_arrow"
	changed_keys = list(
		"NORTHEAST" = "swaphand",
		"SOUTHEAST" = "attackself",
		"NORTHWEST" = "drop",
		"SOUTHWEST" = "togglethrow"
	)

/datum/keybind_style/human/tg
	name = "human_tg"
	changed_keys = list(
	"SPACE" = KEY_RUN,
	"SHIFT" = KEY_EXAMINE,
	"R" = KEY_THROW,
	"E" = "equip",
	"X" = "swaphand",
	"Z" = "attackself",
	"Q" = "drop"
	)

/datum/keybind_style/human/azerty
	name = "human_azerty"
	changed_keys = list(
		"A" = "drop"
	)

///
///	ROBOT-SPECIFIC KEYBINDS
///

/datum/keybind_style/robot
	name = "robot"
	changed_keys = list(
		"SHIFT" = KEY_BOLT,
		"CTRL" = KEY_OPEN,
		"ALT" = KEY_EXAMINE,
		"SPACE" = KEY_SHOCK,
		"1" = "module1",
		"2" = "module2",
		"3" = "module3",
		"4" = "module4",
		"B" = KEY_POINT,
		"E" = "swaphand",
		"C" = "attackself",
		"Q" = "unequip"
	)

/datum/keybind_style/robot/arrow
	name = "robot_arrow"
	changed_keys = list(
		"NORTHEAST" = "swaphand",
		"SOUTHEAST" = "attackself",
		"NORTHWEST" = "unequip"
	)

/datum/keybind_style/robot/tg
	name = "robot_tg"
	changed_keys = list(
		"CTRL" = KEY_BOLT,
		"SHIFT" = KEY_OPEN,
		"ALT" = KEY_SHOCK,
		"SPACE" = KEY_EXAMINE,
		"X" = "swaphand",
		"Z" = "attackself",
	)

/datum/keybind_style/robot/azerty
	name = "robot_azerty"
	changed_keys = list(
		"A" = "unequip"
	)

///
///	DRONE-SPECIFIC KEYBINDS
///

/datum/keybind_style/drone
	name = "drone"
	changed_keys = list(
		"B" = KEY_POINT,
		"C" = "attackself",
		"Q" = "unequip"
	)

/datum/keybind_style/drone/arrow
	name = "drone_arrow"
	changed_keys = list(
		"SOUTHEAST" = "attackself", /*PGDN*/
		"NORTHWEST" = "unequip" /*HOME*/
	)

/datum/keybind_style/drone/tg
	name = "drone_tg"
	changed_keys = list(
		"Z" = "attackself",
	)

/datum/keybind_style/drone/azerty
	name = "drone_azerty"
	changed_keys = list(
		"A" = "unequip"
	)

///
///	MISC-SPECIFIC KEYBINDS
///

/datum/keybind_style/pod
	name = "pod"
	changed_keys = list(
		"SPACE" = "fire"
	)

/datum/keybind_style/torpedo
	name = "torpedo"
	changed_keys = list(
		"SPACE" = "fire",
		"E" = "exit",
		"Q" = "exit"
	)

/datum/keybind_style/col_putt
	name = "colputt"
	changed_keys = list(
		"SPACE" = "fire",
		"Q" = "stop",
		"E" = "alt_fire"
	)

/datum/keybind_style/col_putt/arrow
	name = "colputt_arrow"
	changed_keys = list(
		"SOUTHEAST" = "fire", /*PGDN*/
		"NORTHWEST" = "stop", /*HOME*/
		"NORTHEAST" = "alt_fire" /*PGUP*/
	)

/datum/keybind_style/artillery
	name = "art"
	changed_keys = list(
		"SPACE" = "fire",
		"Q" = "cycle"
	)