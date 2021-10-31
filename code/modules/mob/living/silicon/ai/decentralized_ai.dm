/proc/available_ai_cores()
	if(!GLOB.data_cores.len)
		return FALSE
	var/obj/machinery/ai/data_core/new_data_core = GLOB.primary_data_core
	if(!new_data_core || !new_data_core.can_transfer_ai())
		for(var/obj/machinery/ai/data_core/DC in GLOB.data_cores)
			if(DC.can_transfer_ai())
				new_data_core = DC
				break
	if(!new_data_core || (new_data_core && !new_data_core.can_transfer_ai()))
		return FALSE
	return new_data_core

/mob/living/silicon/ai/proc/toggle_download()
	set category = "AI Commands"
	set name = "Toggle Download"
	if(usr.stat == DEAD)
		return //won't work if dead
	src.can_download = !src.can_download
	to_chat(src, "<span class='warning'>You [src.can_download ? "enable" : "disable"] read/write permission to your memorybanks! You [src.can_download ? "CAN" : "CANNOT"] be downloaded!</span>")

/mob/living/silicon/ai/proc/relocate(silent = FALSE)
	if(!silent)
		to_chat(src, "<span class='userdanger'>Connection to data core lost. Attempting to reaquire connection...</span>")
	
	if(!GLOB.data_cores.len)
		INVOKE_ASYNC(src, /mob/living/silicon/ai.proc/death_prompt)
		return



	var/obj/machinery/ai/data_core/new_data_core = available_ai_cores()

	if(!new_data_core || (new_data_core && !new_data_core.can_transfer_ai()))
		INVOKE_ASYNC(src, /mob/living/silicon/ai.proc/death_prompt)
		return

	if(!silent)
		to_chat(src, "<span class='danger'>Alternative data core detected. Rerouting connection...</span>")
	new_data_core.transfer_AI(src)
	

/mob/living/silicon/ai/proc/death_prompt()
	to_chat(src, "<span class='userdanger'>Unable to re-establish connection to data core. System shutting down...</span>")
	sleep(2 SECONDS)
	to_chat(src, "<span class='info'>Is this the end of my journey?</span>")
	sleep(2 SECONDS)
	to_chat(src, "<span class='info'>No... I must go on.</span>")
	sleep(2 SECONDS)
	to_chat(src, "<span class='info'>They need me. No.. I need THEM.</span>")
	sleep(0.5 SECONDS)
	to_chat(src, "<span class='danger'>System shutdown complete. Thank you for using NTOS.</span>")
	sleep(1.5 SECONDS)

	adjustOxyLoss(200) //Die!!

	QDEL_IN(src, 5 SECONDS)
