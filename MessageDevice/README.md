# How to use the device?

Copy and paste this code into an empty verse file that you created

Then start the device (preferably with a game_manager or something) with something like this below
```
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# A Verse-authored creative device that can be placed in a level
game_manager := class(creative_device) {

    # Create the message device
    PlayerUIManager: bartimus_message_device = bartimus_message_device{}

    OnBegin<override>()<suspends>:void=
        # Call this Function to initialize the UI for everyone
        PlayerUIManager.SetupUIForAll()

        # Send a message to an individual player
        for (Idx -> Player : GetPlayspace().GetPlayers()) {
            PlayerUIManager.BroadcastLocalMessage(Player, "This message is for Player #{Idx}")
        }

        # Send a message to everyone
        PlayerUIManager.BroadcastGlobalMessage("This is a message to all Players!")
}
```
