import Control.Monad (liftM2)

import Data.Default (def)

import XMonad
import XMonad.Hooks.DynamicLog (xmobar)
import XMonad.Hooks.FadeWindows
    ( FadeHook
    , fadeWindowsEventHook
    , fadeWindowsLogHook
    , isUnfocused
    , transparency
    )
import XMonad.Hooks.SetWMName (setWMName)
import qualified XMonad.StackSet as W (greedyView, shift)
import XMonad.Util.EZConfig (additionalKeys)

--main = xmonad =<< statusBar myXmobar myPP toggleStrutsKey  myConfig
--myXmobar = "~/.cabal/bin/xmobar"
main :: IO ()
main = xmonad =<< xmobar myConfig

myWorkspaces :: [String]
myWorkspaces = [ "main"
               , "dev1"
               , "dev2"
               , "web"
               , "docs"
               , "media"
               ]

myManageHook :: ManageHook
myManageHook = composeAll . concat $
    [   [ className =? b --> viewShift "web"      | b <- myWebShifts  ]
    --  , [ resource  =? c --> doF (W.shift "chat") | c <- myClassChatShifts ]
    ]
    where
       viewShift = doF . liftM2 (.) W.greedyView W.shift
       myWebShifts = ["Firefox" {- Firefox -}]

myConfig = def
    { terminal = myUrxvt
    , borderWidth = 2
    , normalBorderColor = "black"
    , focusedBorderColor = "gray"
    , handleEventHook = fadeWindowsEventHook
    , workspaces = myWorkspaces
    , manageHook = myManageHook
    , startupHook = myStartupHook
    } `additionalKeys` myCustomBindings

myCustomBindings :: [((ButtonMask, KeySym), X ())]
myCustomBindings =
    [ ((mod1Mask, xK_r), spawn "dmenu_run -b")
    , ((mod1Mask, xK_u), spawn "setxkbmap us")
    , ((mod1Mask, xK_c), spawn "setxkbmap cz")
    ]

myStartupHook :: X ()
myStartupHook = setWMName "LG3D"

myUrxvt :: String
myUrxvt = concat $
    [ "urxvt"
    , " -fg rgb:0000/ffff/0000"
    , " -bg rgba:0000/0000/0000/ee00"
    , " -cr rgb:ffff/ffff/0000"
    , " -transparent"
    , " -depth 32"
    , " +sb"
    ]
