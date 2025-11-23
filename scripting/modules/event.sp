void Event_Create() {
    HookEvent("player_team", OnPlayerTeam, EventHookMode_Pre);
    HookEvent("player_disconnect", OnPlayerDisconnect, EventHookMode_Pre);
}

static Action OnPlayerTeam(Event event, const char[] name, bool dontBroadcast) {
    int userId = event.GetInt("userid");
    int client = GetClientOfUserId(userId);
    int team = event.GetInt("team");

    if (Client_IsTeamEventDisabled(client) && team == TEAM_SPECTATOR) {
        event.BroadcastDisabled = true;

        Client_EnableTeamEvent(client);

        return Plugin_Changed;
    }

    return Plugin_Continue;
}

static Action OnPlayerDisconnect(Event event, const char[] name, bool dontBroadcast) {
    int userId = event.GetInt("userid");
    int client = GetClientOfUserId(userId);

    if (Client_IsKickEventDisabled(client)) {
        event.BroadcastDisabled = true;

        return Plugin_Changed;
    }

    return Plugin_Continue;
}
