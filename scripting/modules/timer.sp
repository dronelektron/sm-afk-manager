static Handle g_afkTimer;

void Timer_CheckPlayers_Reset() {
    g_afkTimer = null;
}

void Timer_CheckPlayers_Create() {
    if (g_afkTimer == null) {
        g_afkTimer = CreateTimer(TIMER_INTERVAL, OnCheckPlayers, _, TIMER_FLAGS);
    }
}

static Action OnCheckPlayers(Handle timer) {
    UseCase_CheckPlayers();

    return g_afkTimer == null ? Plugin_Stop : Plugin_Continue;
}
