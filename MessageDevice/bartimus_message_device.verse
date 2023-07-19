
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

bartimus_message_device := class(creative_device) {

    MessageShowTime : float = 3.0
    UIText<localizes>(Value: string) : message = "{Value}"
    EmptyText<localizes>(Value: string) : message = ""
    GlobalTextWidget : text_block = text_block{}
    var LocalTextWidgetMappings : [player]text_block = map{}

    (Player: player ).SetupUI(PlayerUI: player_ui): void = {
        LocalTextWidget: text_block  = text_block{}
        if (set LocalTextWidgetMappings[Player] = LocalTextWidget) {
            LocalCanvas : canvas = canvas {
                Slots := array {
                    canvas_slot {
                        Widget := LocalTextWidget
                        Anchors := anchors{
                            Minimum := vector2 { X:= 0.01, Y:= 0.5},
                            Maximum := vector2 { X:= 0.01, Y:= 0.5}
                        }
                        Alignment := vector2 {
                            X := 0.0,
                            Y := 0.5
                        }
                        SizeToContent := true
                    }
                }
            }
            PlayerUI.AddWidget(LocalCanvas)
        }    
        GlobalCanvas : canvas = canvas {
            Slots := array {
                canvas_slot {
                    Widget := GlobalTextWidget
                    Anchors := anchors{
                        Minimum := vector2 { X:= 0.99, Y:= 0.5},
                        Maximum := vector2 { X:= 0.99, Y:= 0.5}
                    }
                    Alignment := vector2 {
                        X := 1.0,
                        Y := 0.5
                    }
                    SizeToContent := true
                }
            }
        }
        PlayerUI.AddWidget(GlobalCanvas)
    }

    BroadcastLocalMessage<public>(Player: player, Message: string): void = {
        if(local_ui := LocalTextWidgetMappings[Player]) {
            spawn { QueueClearMessage(local_ui) }
            local_ui.SetText(UIText("Local: {Message}"))
        }
    }
    BroadcastGlobalMessage<public>(Message: string): void = {
        spawn { QueueClearMessage(GlobalTextWidget) }
        GlobalTextWidget.SetText(UIText("Global: {Message}"))
    }

    QueueClearMessage<public>(TextToClear: text_block)<suspends> : void = {
        Sleep(MessageShowTime)
        TextToClear.SetText(EmptyText())
    }

    SetupUIForAll<public>(): logic = {
        for (Player : GetPlayspace().GetPlayers(), PlayerUI := GetPlayerUI[Player], FortCharacter := Player.GetFortCharacter[]) {
            Player.SetupUI(PlayerUI)
        }
        return true
    }
}
