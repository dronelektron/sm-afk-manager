static int g_kickSeconds[MAXPLAYERS + 1];
static int g_moveSeconds[MAXPLAYERS + 1];
static bool g_teamEventDisabled[MAXPLAYERS + 1];
static bool g_kickEventDisabled[MAXPLAYERS + 1];

void Client_ResetSeconds(int client) {
    g_kickSeconds[client] = 0;
    g_moveSeconds[client] = 0;
}

int Client_GetKickSeconds(int client) {
    return g_kickSeconds[client];
}

void Client_AddKickSeconds(int client) {
    g_kickSeconds[client]++;
}

int Client_GetMoveSeconds(int client) {
    return g_moveSeconds[client];
}

void Client_AddMoveSeconds(int client) {
    g_moveSeconds[client]++;
}

void Client_EnableTeamEvent(int client) {
    g_teamEventDisabled[client] = false;
}

void Client_DisableTeamEvent(int client) {
    g_teamEventDisabled[client] = true;
}

bool Client_IsTeamEventDisabled(int client) {
    return g_teamEventDisabled[client];
}

void Client_EnableKickEvent(int client) {
    g_kickEventDisabled[client] = false;
}

void Client_DisableKickEvent(int client) {
    g_kickEventDisabled[client] = true;
}

bool Client_IsKickEventDisabled(int client) {
    return g_kickEventDisabled[client];
}
