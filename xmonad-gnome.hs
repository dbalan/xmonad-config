import XMonad
import XMonad.Config.Gnome
import XMonad.Util.Run
import XMonad.Util.EZConfig

-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

initProgs = [ ("setxkbmap", ["-option", "ctrl:nocaps"])
            , ("emacs", ["--daemon"])
	    , ("kupfer", ["--no-splash"])
            -- , ("diodon", [])
            ]

main = do
  xmonad $ gnomeConfig
    { terminal    = "gnome-terminal"
    , modMask     = mod4Mask
    , focusFollowsMouse = False
    , borderWidth = 3
    , focusedBorderColor = "#e57a10"
    , startupHook = do
        startupHook gnomeConfig
        startProgs initProgs
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "google-chrome" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    , ("M-p", safeSpawn "kupfer" [])
    ]
