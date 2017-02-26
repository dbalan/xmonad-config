{-
Launch xmonad with KDE. Works with KDE5
https://wiki.haskell.org/Xmonad/Using_xmonad_in_KDE
-}
import XMonad
import XMonad.Config.Kde
import qualified XMonad.StackSet as W -- to shift and float windows
import XMonad.Util.Run
import XMonad.Util.EZConfig

-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

initProgs = [ ("setxkbmap", ["-option", "ctrl:nocaps"])
            , ("emacs", ["--daemon"])
            -- , ("kupfer", ["--no-splash"])
            -- , ("diodon", [])
            ]

main = do
  xmonad $ kdeConfig
    { terminal    = "gnome-terminal"
    , modMask     = mod4Mask
    , focusFollowsMouse = False
    , borderWidth = 3
    , focusedBorderColor = "#e57a10"
    , startupHook = do
        startupHook kdeConfig
        startProgs initProgs
    , manageHook = manageHook kdeConfig <+> customKdeManageHook
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "firefox" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    , ("M-p", safeSpawn "krunner" [])
    ]


customKdeManageHook = composeAll . concat $
  [
    [className =? c --> doFloat | c <- kdeFloats]
  ]
  where kdeFloats = ["krunner", "plasma-desktop", "Plasma-desktop", "kmix", "plasmashell"]
