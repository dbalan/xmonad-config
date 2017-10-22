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


-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

initProgs = [ ("setxkbmap", ["-option", "ctrl:nocaps"])
            , ("emacs", ["--daemon"])
            -- , ("kupfer", ["--no-splash"])
            -- , ("diodon", [])
            ]

main = do
  xmonad $ kdeConfig
    { terminal    = "/home/dj/localbuild/bin/st"
    , modMask     = mod4Mask
    , focusFollowsMouse = False
    , borderWidth = 3
    , focusedBorderColor = "#e57a10"
    , startupHook = do
        startupHook kdeConfig
        startProgs initProgs
    , manageHook = manageHook kdeConfig <+> customKdeManageHook <+> manageDocks
    , handleEventHook = handleEventHook kdeConfig <+> fullscreenEventHook
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "firefox" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    -- going to let KDE do this.
    , ("M-p", safeSpawn "dmenu_run" [])
    ]


customKdeManageHook = composeAll . concat $
  [
    [className =? c --> doFloat | c <- kdeFloats]
  ]
  where kdeFloats = ["krunner", "plasma-desktop", "Plasma-desktop", "kmix", "plasmashell"]
