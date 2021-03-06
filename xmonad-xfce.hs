import XMonad
import XMonad.Config.Xfce
import XMonad.Util.Run
import XMonad.Util.EZConfig

-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

initProgs = [ ("emacs", ["--daemon"])
	    , ("xfce4-panel", ["--disable-wm-check"])
            -- , ("diodon", [])
            ]

main = do
  xmonad $ xfceConfig
    { terminal    = "sakura"
    , modMask     = mod4Mask
    , focusFollowsMouse = False
    , borderWidth = 3
    , focusedBorderColor = "#e57a10"
    , startupHook = do
        startupHook xfceConfig
        startProgs initProgs
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "chrome" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    , ("M-[", safeSpawn "dmenu_run" [])
    ]

