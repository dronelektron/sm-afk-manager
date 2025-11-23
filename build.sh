#!/bin/bash

cd scripting

PLUGIN_NAME="afk-manager"
AFK_DETECTOR="../../afk-detector/scripting/include"
$SP_1_12 $PLUGIN_NAME.sp -i include -i $AFK_DETECTOR -o ../plugins/$PLUGIN_NAME.smx
