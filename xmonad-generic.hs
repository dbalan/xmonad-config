import XMonad
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Actions.WindowBringer
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Tabbed (simpleTabbed)

-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

initProgs = [ ("emacs", ["--daemon"])
            , ("xscreensaver", [])
            ]


customLayout = avoidStruts ( tiled ||| Mirror tiled ||| Full ||| simpleTabbed ) ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    delta = 3/100
    ratio = 1/2

main = do
  xmonad $ defaultConfig
    { terminal    = "sakura"
    , modMask     = mod4Mask
    , focusFollowsMouse = True
    , borderWidth = 1
    , layoutHook = smartBorders $ customLayout
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

    -- multimedia keys
    -- , ("<XF86AudioMute>", safeSpawn "") -- already handled
    , ("<XF86AudioRaiseVolume>", spawn "mixer vol +4")
    , ("<XF86AudioLowerVolume>", spawn "mixer vol -4")
    ]
