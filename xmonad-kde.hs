{-
Launch xmonad with KDE. Works with KDE5
https://wiki.haskell.org/Xmonad/Using_xmonad_in_KDE
-}
import XMonad
import XMonad.Config.Kde
import qualified XMonad.StackSet as W -- to shift and float windows
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.MouseResizableTile (mouseResizableTile)

-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

-- only spawn things that are needed by xmonad. Use systemd/User for everything
-- else.
initProgs = [ ("setxkbmap", ["-option", "ctrl:nocaps"]) ]

customLayout = desktopLayoutModifiers $ tiled ||| Mirror tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    delta = 3/100
    ratio = 1/2
main = do
  xmonad $ kdeConfig
    { terminal    = "gnome-terminal"
    , layoutHook  = avoidStruts customLayout ||| smartBorders Full
    , modMask     = mod4Mask
    , focusFollowsMouse = False
    , borderWidth = 2
    , focusedBorderColor = "#e57a10"
    , startupHook = do
        startupHook kdeConfig
        startProgs initProgs
    , manageHook = manageHook kdeConfig <+> customWindowRules <+> customKdeManageHook <+> manageDocks
    , handleEventHook = handleEventHook kdeConfig <+> fullscreenEventHook
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "firefox" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    -- going to let KDE do this.
    , ("M-[", safeSpawn "dmenu_run" [])
    -- , ("M-o", safeSpawn "zeal" []) -- runs always
    ]
    `additionalMouseBindings`
    [ ((0, 8), const $ safeSpawn "xdotool" ["key", "XF86AudioPrev"])
    , ((0, 9), const $ safeSpawn "xdotool" ["key", "XF86AudioNext"])
    ]

customWindowRules = composeAll
  [ className =? "Zeal" --> doShift "4"
  , className =? "Slack" --> doShift "9"
  , className =? "Spotify" --> doShift "8"
  , className =? "Clementine" --> doShift "8"
  ]

customKdeManageHook = composeAll . concat $
  [
    [className =? c --> doFloat | c <- kdeFloats]
  -- , [isDialog --> doCenterFloat ]
  ]
  where kdeFloats = ["krunner", "plasma-desktop", "Plasma-desktop", "kmix", "plasmashell"]
