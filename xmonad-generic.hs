import XMonad
import XMonad.Util.Run
import XMonad.Util.EZConfig

-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

main = do
  xmonad $ defaultConfig
    { terminal    = "sakura"
    , modMask     = mod4Mask
    , focusFollowsMouse = False
    , borderWidth = 3
    , focusedBorderColor = "#e57a10"
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "chrome" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    , ("M-[", safeSpawn "dmenu_run" [])
    ]

