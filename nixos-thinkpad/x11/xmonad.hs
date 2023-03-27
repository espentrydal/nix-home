import XMonad
import XMonad.Config.Xfce

main = xmonad xfceConfig
    { terminal    = "alacritty"
    , modMask     = mod4Mask
    }
