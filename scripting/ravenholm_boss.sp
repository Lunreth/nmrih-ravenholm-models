#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

bool g_bEnabled;

public Plugin myinfo =
{
	name = "[NMRIH] NMO_Ravenholm Model",
	author = "Ulreth & Dysphie",
	description = "Custom model for nmo_ravenholm",
	version = "1.1",
	url = "https://steamcommunity.com/groups/lunreth-laboratory"
};

public void OnMapStart()
{
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, sizeof(map));
	// CHECKS MAP NAME
	if(StrContains(map, "nmo_ravenholm") != -1)
    {
        PrecacheModel("models/zombie/fast.mdl");
        g_bEnabled = true;
    }
    else
    {
        g_bEnabled = false;
    }
	
}

public void OnEntityCreated(int entity, const char[] classname)
{
	// CHECK IF MAP IS VALID
	if(!g_bEnabled)
        return;
	// WILL HOOK ANY KID ZOMBIE SPAWN
	if(StrEqual(classname, "npc_nmrih_kidzombie"))
		SDKHook(entity, SDKHook_SpawnPost, OnKidSpawned);
}

public void OnKidSpawned(int zombie)
{
	char targetname[64];
	GetEntPropString(zombie, Prop_Send, "m_iName", targetname, sizeof(targetname));
	// SEARCH FOR BOSS NAME AND APPLY MODEL
	if(StrEqual(targetname, "boss"))
	{
		SetEntProp(zombie, Prop_Send, "m_nModelIndex", PrecacheModel("models/zombie/fast.mdl"));
		SetEntityModel(zombie, "models/zombie/fast.mdl");
	}
}