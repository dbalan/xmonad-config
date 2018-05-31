import XMonad
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Actions.WindowBringer
import XMonad.Layout.NoBorders (smartBorders)

-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

initProgs = [ ("emacs", ["--daemon"])
            , ("xscreensaver", [])
            ]
main = do
  xmonad $ defaultConfig
    { terminal    = "sakura"
    , modMask     = mod4Mask
    , focusFollowsMouse = True
    , borderWidth = 1
    , layoutHook = smartBorders $ layoutHook defaultConfig
    , startupHook = do
        startupHook defaultConfig
        startProgs initProgs
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "chrome" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    , ("M-[", safeSpawn "dmenu_run" [])
    -- window bringer actions
    , ("M-S-g", gotoMenu)
    , ("M-S-k", bringMenu)
    ]

