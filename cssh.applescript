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

  set numColumns to (round ((count serverList) ^ 0.5) rounding up)

  set allSessions to {}
  set columnTops to {}

  tell application "iTerm"

    -- create column tops
    set newWindow to (create window with default profile)
    tell newWindow
      copy current session to end of |allSessions|
      copy current session to end of |columnTops|
      tell current session
        repeat numColumns - 1 times
          set newSession to (split vertically with default profile)
          copy newSession to end of |allSessions|
          copy newSession to end of |columnTops|
          tell newSession to select
        end repeat
      end tell
    end tell

    -- split each column
    set columnsDone to 0
    repeat with columnTop in columnTops
      tell columnTop
        -- calculate how many vertical panes we need here
        set numVertical to (round(((count serverList)-(count allSessions))/(numColumns-columnsDone)) rounding up) + 1
        repeat numVertical - 1 times
          copy (split horizontally with default profile) to end of |allSessions|
        end repeat
        set columnsDone to columnsDone + 1
      end tell
    end repeat

    -- run ssh commands on all sessions
    repeat with loopIndex from 1 to number of items in allSessions
      tell item loopIndex of allSessions
        write text "ssh " & (item loopIndex of serverList)
      end tell
    end repeat

    -- enable broadcast
    tell application "System Events" to keystroke "I" using {command down, shift down}

  end tell

end run
