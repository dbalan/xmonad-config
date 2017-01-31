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
    -- WIP: not ready yet , manageHook = manageHook kdeConfig <+> customManageHook
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "firefox" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    , ("M-p", safeSpawn "krunner" [])
    ]


customManageHook = composeAll . concat $
    [ [ className   =? c --> doFloat           | c <- myFloats]
    , [ title       =? t --> doFloat           | t <- myOtherFloats]
    , [ className   =? c --> doF (W.shift "1") | c <- webApps]
    , [ className   =? c --> doF (W.shift "9") | c <- commApps]
    ]
  where myFloats      = ["MPlayer", "Gimp"]
        myOtherFloats = ["alsamixer"]
        webApps       = ["Firefox-bin", "Opera"] -- open on desktop 2
        commApps       = ["KMail", "Slack - Cliqz"]  -- open on desktop 9

