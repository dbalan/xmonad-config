import XMonad
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Actions.WindowBringer
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Tabbed (simpleTabbed)
import XMonad.Config.Desktop

-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

initProgs = [ ("emacs", ["--daemon"])
            , ("xscreensaver", [])
            , ("feh", ["--bg-scale", "/home/dhananjay/Desktop/bg.jpg"])
            ]


customLayout = avoidStruts ( tiled ||| Mirror tiled ||| Full ||| simpleTabbed ) ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    delta = 3/100
    ratio = 1/2

statusBar = "i3status -c /home/dhananjay/.xmonad/i3statusrc | " ++
  "dzen2 -dock -x '0' -y '-1' -fn '-*-profont-*-*-*-*-11-*-*-*-*-*-iso8859'"
main = do
  sp <- spawnPipe statusBar
  xmonad $ desktopConfig
    { terminal    = "gnome-terminal"
    , modMask     = mod4Mask
    , focusFollowsMouse = True
    , borderWidth = 1
    , layoutHook = smartBorders $ customLayout
    , handleEventHook = docksEventHook <+> handleEventHook desktopConfig
    , manageHook = manageDocks <+> manageHook desktopConfig
    , startupHook = do
        startupHook desktopConfig
        startProgs initProgs
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "chrome" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    , ("M-[", safeSpawn "dmenu_run" [])
    -- window bringer actions
    , ("M-S-g", gotoMenu)
    , ("M-S-k", bringMenu)

    , ("C-M1-l", spawn "xscreensaver-command -lock")

    -- multimedia keys
    -- , ("<XF86AudioMute>", safeSpawn "") -- already handled
    , ("<XF86AudioRaiseVolume>", spawn "mixer vol +4")
    , ("<XF86AudioLowerVolume>", spawn "mixer vol -4")
    ]
