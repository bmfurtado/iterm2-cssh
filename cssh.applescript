#!/usr/bin/osascript

-- Launches multiple SSH session
-- completely rewritten but inspired by github:xgdlm/iterm2-cssh

on run argv

    set serverList to argv

    -- Print help if no servers are given
    if (count serverList) = 0
        log("usage: iterm2-cssh [user@]hostname ...")
        return
    end if

    set rightArrow to ASCII character 29

    set numServers to count serverList

    set numHorizontal to (round (numServers ^ 0.5) rounding up)

    set createdPanels to 1

    tell application "iTerm"

        activate
        set myterm to (make new terminal)
        tell myterm
            launch session "Default Session"

            -- create the horizontal panels
            repeat numHorizontal - 1 times
                    tell i term application "System Events" to keystroke "d" using {command down}
                    set createdPanels to createdPanels + 1
            end repeat

            set splitColumns to 0

            -- split each of the panels vertically
            repeat createdPanels times
                -- re-evaluate number of vertical panels we need
                set numVertical to (round((numServers-createdPanels)/(numHorizontal-splitColumns)) rounding up) + 1
                tell i term application "System Events" to keystroke rightArrow using {option down, command down}
                repeat numVertical - 1 times
                    if createdPanels is less than numServers
                        tell i term application "System Events" to keystroke "d" using {command down, shift down}
                        set createdPanels to createdPanels + 1
                    end if
                end repeat
                set splitColumns to splitColumns+1
            end repeat

            -- open ssh sessions--
            repeat with loopIndex from 1 to numServers
                set currentServer to item loopIndex of serverList
                tell item loopIndex of sessions to write text "ssh " & currentServer
            end repeat

            -- introducing delay to avoid weirdness
            delay 1

            tell i term application "System Events" to keystroke "I" using {command down, shift down}

        end tell
    end tell
end run
