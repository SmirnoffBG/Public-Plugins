/* Sublime AMXX Editor v2.2 */

#include <amxmodx>
#include <amxmisc>
// #include <cstrike>
// #include <engine>
// #include <fakemeta>
#include <hamsandwich>
#include <reapi>
// #include <fun>
// #include <xs>
// #include <sqlx>

#define PLUGIN  "Refill Assist"
#define VERSION "1.1"
#define AUTHOR  "SmirnoffBG"

new g_bitDamageDone[33]

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	RegisterHam(Ham_TakeDamage, "player", "DamageDone", 1)
	RegisterHam(Ham_Killed, "player", "umirane", 1)
}

public DamageDone(iVictim, iInflictor, iAttacker)
{
	if(is_user_connected(iAttacker) && iAttacker != 0)
		g_bitDamageDone[iVictim]  |= ( 1 << (iAttacker & 31) )
}

public umirane(id, killer)
{
	if(is_user_alive(killer))
	{
		rg_instant_reload_weapons(killer)
		set_task(0.5, "SecondReload", killer)
	}

	if(g_bitDamageDone[id] != ( 1 << (killer & 31))) // if attacker is not just the killer
	{
		new iPl[32], iNum, iAssist
		get_players_ex(iPl, iNum, GetPlayers_ExcludeDead)
		for(--iNum; iNum>-1; iNum--)
		{
			iAssist = iPl[iNum]
			if(g_bitDamageDone[id] & ( 1 << (iAssist & 31)))
			{
				rg_instant_reload_weapons(iAssist)
			}
		}
	}
	g_bitDamageDone[id] = 0
	
}

public SecondReload(killer)
{
	if(is_user_alive(killer))
		rg_instant_reload_weapons(killer)
}
