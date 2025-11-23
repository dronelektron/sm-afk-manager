void UseCase_OnClientActive(int client) {
    Client_ResetSeconds(client);
}

void UseCase_OnClientInactive(int client) {
    Timer_CheckPlayers_Create();

    if (IsSpectator(client)) {
        NotifyAboutKick(client);
    } else {
        NotifyAboutMove(client);
    }
}

void UseCase_CheckPlayers() {
    int inactiveAmount = 0;

    for (int client = 1; client <= MaxClients; client++) {
        if (IsClientInGame(client) && IsClientInactive(client)) {
            inactiveAmount++;
        }
    }

    if (inactiveAmount == 0) {
        Timer_CheckPlayers_Reset();
    }
}

static bool IsClientInactive(int client) {
    if (IsFakeClient(client) || AfkDetector_IsClientActive(client)) {
        return false;
    }

    if (IsSpectator(client)) {
        CheckKickSeconds(client);
    } else {
        CheckMoveSeconds(client);
    }

    return true;
}

static void NotifyAboutKick(int client, int clientKickSeconds = 0) {
    if (NotEnoughClientsForKick()) {
        return;
    }

    if (IsClientHaveImmunity(client, AFK_IMMUNITY_KICK)) {
        return;
    }

    int kickSeconds = Variable_KickSeconds() - clientKickSeconds;

    Message_InactiveSpectator(client, kickSeconds);
}

static void NotifyAboutMove(int client, int clientMoveSeconds = 0) {
    if (NotEnoughClientsForMove()) {
        return;
    }

    if (IsClientHaveImmunity(client, AFK_IMMUNITY_MOVE)) {
        return;
    }

    int moveSeconds = Variable_MoveSeconds() - clientMoveSeconds;

    Message_InactivePlayer(client, moveSeconds);
}

static void CheckKickSeconds(int client) {
    Client_AddKickSeconds(client);

    if (NotEnoughClientsForKick()) {
        return;
    }

    if (IsClientHaveImmunity(client, AFK_IMMUNITY_KICK)) {
        return;
    }

    int clientKickSeconds = Client_GetKickSeconds(client);
    int kickSeconds = Variable_KickSeconds();

    if (clientKickSeconds >= kickSeconds) {
        Client_DisableKickEvent(client);
        KickClient(client, "%t", "You are kicked for inactivity");
        Message_ClientKicked(client);
    } else if (IsRepeatKickNotification(clientKickSeconds)) {
        NotifyAboutKick(client, clientKickSeconds);
    }
}

static void CheckMoveSeconds(int client) {
    Client_AddMoveSeconds(client);

    if (NotEnoughClientsForMove()) {
        return;
    }

    if (IsClientHaveImmunity(client, AFK_IMMUNITY_MOVE)) {
        return;
    }

    int clientMoveSeconds = Client_GetMoveSeconds(client);
    int moveSeconds = Variable_MoveSeconds();

    if (clientMoveSeconds >= moveSeconds) {
        Client_DisableTeamEvent(client);
        ChangeClientTeam(client, TEAM_SPECTATOR);
        Message_PlayerMovedToSpectators(client);
        NotifyAboutKick(client);
    } else if (IsRepeatMoveNotification(clientMoveSeconds)) {
        NotifyAboutMove(client, clientMoveSeconds);
    }
}

static bool IsRepeatKickNotification(int seconds) {
    int interval = Variable_KickNotificationInterval();

    return IsRepeatNotification(interval, seconds);
}

static bool IsRepeatMoveNotification(int seconds) {
    int interval = Variable_MoveNotificationInterval();

    return IsRepeatNotification(interval, seconds);
}

static bool IsRepeatNotification(int interval, int seconds) {
    return interval == 0 ? false : (seconds % interval == 0);
}

static bool NotEnoughClientsForKick() {
    return GetClientCount() < Variable_KickMinPlayers();
}

static bool NotEnoughClientsForMove() {
    return GetClientCount() < Variable_MoveMinPlayers();
}

static bool IsClientHaveImmunity(int client, int immunity) {
    int adminImmunity = Variable_AdminImmunity();

    if (IsAdmin(client) && adminImmunity > AFK_IMMUNITY_NONE) {
        return IsPartialOrFullImmunity(adminImmunity, immunity);
    }

    int playerImmunity = Variable_PlayerImmunity();

    return IsPartialOrFullImmunity(playerImmunity, immunity);
}

static bool IsPartialOrFullImmunity(int variableImmunity, int immunity) {
    return variableImmunity == immunity || variableImmunity == AFK_IMMUNITY_FULL;
}

static bool IsAdmin(int client) {
    AdminId id = GetUserAdmin(client);

    return id != INVALID_ADMIN_ID && GetAdminFlag(id, Admin_Generic, Access_Effective);
}

static bool IsSpectator(int client) {
    return GetClientTeam(client) == TEAM_SPECTATOR;
}

void UseCase_CheckAfkStatus(int client, int target) {
    int seconds = Client_GetKickSeconds(target) + Client_GetMoveSeconds(client);

    Message_AfkStatus(client, target, seconds);
}

void UseCase_ResetSeconds(int client, int target) {
    Client_ResetSeconds(client);
    Message_ResetSeconds(client, target);
}
