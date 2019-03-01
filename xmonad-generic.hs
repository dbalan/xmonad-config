import XMonad
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Actions.WindowBringer
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.MouseResizableTile (mouseResizableTile)
import XMonad.Config.Desktop
-- rewrite the start progs
startProgs prgs = mapM_ (\(cmd,args) -> safeSpawn cmd args) prgs

initProgs = [ ("emacs", ["--daemon"])
            , ("xscreensaver", [])
            , ("feh", ["--bg-scale", "/home/dhananjay/Desktop/munich.jpg"])
            ]


customLayout = avoidStruts ( tiled ||| Mirror tiled ||| Full ||| mouseResizableTile ) ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    delta = 3/100
    ratio = 1/2

font = "'-*-monaco-*-r-normal-*-*-100-*-*-*-*-iso8859-*'"
stdzen = "/home/dhananjay/localbuild/slstatus/slstatus -s | " ++
  "dzen2 -dock -x b -expand left -fn " ++ font
wsdze = "dzen2 -dock -expand right -fn " ++ font

main = do
  _ <- spawn stdzen
  wsdzP <- spawnPipe wsdze
  xmonad $ desktopConfig
    { terminal    = "gnome-terminal"
    , modMask     = mod4Mask
    , focusFollowsMouse = True
    , borderWidth = 1
    , layoutHook = smartBorders $ customLayout
    , logHook = dynamicLogWithPP $ defaultPP { ppOutput = hPutStrLn wsdzP }
    , handleEventHook = docksEventHook <+> handleEventHook desktopConfig
    , manageHook = manageDocks <+> manageHook desktopConfig
    , startupHook = do
        startupHook desktopConfig
        startProgs initProgs
    }
    `additionalKeysP`
    [ ("M-x b", safeSpawn "cliqz" [])
    , ("M-x e", safeSpawn "emacsclient" ["-c"])
    , ("M-[", safeSpawn "dmenu_run" [])
    -- window bringer actions
    , ("M-S-g", gotoMenu)
    , ("M-S-k", bringMenu)

    , ("C-M1-l", spawn "xscreensaver-command -lock")

    -- multimedia keys
    -- , ("<XF86AudioMute>", safeSpawn "") -- already handled
    , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    ]
