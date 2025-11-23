#include <sourcemod>

#include "afk-detector/api"
#include "afk-manager/message"
#include "afk-manager/timer"
#include "afk-manager/use-case"

#include "modules/client.sp"
#include "modules/console-command.sp"
#include "modules/console-variable.sp"
#include "modules/event.sp"
#include "modules/message.sp"
#include "modules/timer.sp"
#include "modules/use-case.sp"

public Plugin myinfo = {
    name = "AFK manager",
    author = "Dron-elektron",
    description = "Allows you to manage inactive players",
    version = "2.0.2",
    url = "https://github.com/dronelektron/afk-manager"
};

public void OnPluginStart() {
    Command_Create();
    Variable_Create();
    Event_Create();
    LoadTranslations("common.phrases");
    LoadTranslations("afk-manager.phrases");
    AutoExecConfig(_, "afk-manager");
}

public void OnMapStart() {
    Timer_CheckPlayers_Reset();
}

public void OnClientConnected(int client) {
    Client_ResetSeconds(client);
    Client_EnableTeamEvent(client);
    Client_EnableKickEvent(client);
}

public void AfkDetector_OnClientActive(int client) {
    UseCase_OnClientActive(client);
}

public void AfkDetector_OnClientInactive(int client) {
    UseCase_OnClientInactive(client);
}
