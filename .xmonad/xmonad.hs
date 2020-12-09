--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
-- Import statements
import XMonad
import Data.Monoid
import System.Exit
import XMonad.Hooks.ManageDocks -- Import so xmobar is not behind windows
import XMonad.Util.SpawnOnce -- Import for spawnOnce command (mjd119)
import XMonad.Util.Run -- Import for spawnPipe (mjd119)
import XMonad.Layout.Tabbed -- Import for tabbed layout (mjd119)
-- import XMonad.Layout.Gaps -- Don't need at the moment
import XMonad.Layout.Spacing -- Import for gaps around windows
import XMonad.Layout.Grid -- Import for grid layout
import XMonad.Layout.NoBorders -- Import for smartBorders (no border when there is 1 window)
-- import XMonad.Layout.Fullscreen -- Import for proper full screen support
import XMonad.Layout.Spiral -- Import for spiral layout (like bspwm's spiral and autotiling for i3)
import XMonad.Hooks.EwmhDesktops -- Import to allow rofi window switcher functionality
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.WindowNavigation -- Import to allow window navigation with keys (directional)
import XMonad.Hooks.DynamicLog -- Import to display statusbar information for xmobar
--import XMonad.Config.Desktop
import XMonad.Actions.SpawnOn -- Import to spawn programs on workspaces (post-compile or on startup)
import XMonad.Util.EZConfig -- Import to create keyboard shortcuts with emacs-like keybinding syntax
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "termite"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 3 -- Was 1 (mjd119)

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["I","II","III","IV","V","VI","VII","VIII","IX"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#333333" -- Was #dddddd (mjd119)
myFocusedBorderColor = "#4c7899" -- Was #ff0000 (mjd119)

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal (mjd119 removed shift key)
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)

    -- launch rofi program launcher (mjd119)
    , ((modm, xK_d), spawn "rofi -show drun -show-icons -icon-theme Flat-Remix-Blue")

    -- launch rofi window switcher (mjd119)
    , ((modm .|. shiftMask, xK_d), spawn "rofi -show window -show-icons -icon-theme Flat-Remix-Blue")

    -- launch rofi run launcher (mjd119)
    , ((modm .|. controlMask, xK_d), spawn "rofi -show run -show-icons -icon-theme Flat-Remix-Blue")

    -- Partial flamshot screenshot (mjd119) [See https://bbs.archlinux.org/viewtopic.php?id=180403 which says to use 0]
    , ((0, xK_Print), spawn "flameshot gui")

    -- Full screenshot with flameshot (mjd119)
    , ((0 .|. shiftMask, xK_Print), spawn "flameshot full --path ~/Pictures/Screenshots/")

    -- Pause/play mpd (mjd119)
    , ((modm .|. shiftMask, xK_p), spawn "mpc toggle")

    -- Use betterlockscreen to lock screen (mjd119)
    , ((modm .|. shiftMask, xK_x), spawn "betterlockscreen -l dim")
    -- Enable 2 dimensional movement (doesn't work with layouts with master window)
    -- Window navigation not enabled on any layouts for now
    , ((modm,                 xK_Right), sendMessage $ Go R)
    , ((modm,                 xK_Left), sendMessage $ Go L)
    , ((modm,                 xK_Up), sendMessage $ Go U)
    , ((modm,                 xK_Down), sendMessage $ Go D)
    , ((modm .|. shiftMask, xK_Right), sendMessage $ XMonad.Layout.WindowNavigation.Swap R)
    , ((modm .|. shiftMask, xK_Left), sendMessage $ XMonad.Layout.WindowNavigation.Swap L)
    , ((modm .|. shiftMask, xK_Up), sendMessage $ XMonad.Layout.WindowNavigation.Swap U)
    , ((modm .|. shiftMask, xK_Down), sendMessage $ XMonad.Layout.WindowNavigation.Swap D)
    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
--    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm .|. shiftMask,              xK_backslash), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask,               xK_m), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_minus     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_equal     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask .|. controlMask, xK_Delete), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. controlMask, xK_c     ), spawn "xmonad --recompile; killall xmobar; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
-- Possible to set with EZConfig module
myEmacsKeys :: [(String, X ())]
myEmacsKeys =
  [
    ("M-<Return>", spawn myTerminal) -- Spawn terminal
  , ("M-d", spawn "rofi -show drun -show-icons -icon-theme Flat-Remix-Blue") -- Rofi run program
  , ("M-S-d", spawn "rofi -show window -show-icons -icon-theme Flat-Remix-Blue") -- Rofi window switcher
  , ("M-C-d", spawn "rofi -show run -show-icons -icon-theme Flat-Remix-Blue") --  Rofi run shell command
  , ("Print", spawn "flameshot gui") -- Take a partial screenshot
  , ("S-Print", spawn "flameshot full --path ~/Pictures/Screenshots/") -- Take a full screenshot
  , ("M-S-p", spawn "mpc toggle") -- Play/Pause Music Player Daemon
  , ("M-S-x", spawn "betterlockscreen -l dim") -- Lock screen
    -- Enable 2 dimensional movement (doesn't work with layouts with master window); window navigation not enabled currently
  , ("M-<Right>", sendMessage $ Go R)
  , ("M-<Left>", sendMessage $ Go L)
  , ("M-<Up>", sendMessage $ Go U)
  , ("M-<Down>", sendMessage $ Go D)
  , ("M-S-<Right>", sendMessage $ XMonad.Layout.WindowNavigation.Swap R)
  , ("M-S-<Left>", sendMessage $ XMonad.Layout.WindowNavigation.Swap L)
  , ("M-S-<Up>", sendMessage $ XMonad.Layout.WindowNavigation.Swap U)
  , ("M-S-<Down>", sendMessage $ XMonad.Layout.WindowNavigation.Swap D)
  -- TODO Fix above window navigation
  , ("M-p", spawn "dmenu_run") -- Open dmenu to open program
  , ("M-S-q", kill) -- Kill focused window
  , ("M-S-\\", sendMessage NextLayout) -- Go to the next layout algorithm (cycle)
--  , ("M-S-<Space>", setLayout $ XMonad.layoutHook conf) TODO Figure out how to convert from original
  , ("M-n", refresh) -- Resize viewed windows to the correct size
  , ("M-<Tab>", windows W.focusDown) -- Move focus to the next window (alternate)
  , ("M-j", windows W.focusDown) -- Move focus to the next window
  , ("M-k", windows W.focusUp) -- Move focus to the previous window
  , ("M-m", windows W.focusMaster) -- Move focus to the master window
  , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
  , ("M-S-j", windows W.swapDown) -- Swap the focused window with the next window
  , ("M-S-k", windows W.swapUp) -- Swap the focused window with the previous window
  , ("M--", sendMessage Shrink) -- Shrink the master area
  , ("M-=", sendMessage Expand) -- Expand the master area
  , ("M-t", withFocused $ windows . W.sink) -- Push window back into tiling mode
  , ("M-,", sendMessage (IncMasterN 1)) -- Increment the number of windows in the master area
  , ("M-.", sendMessage (IncMasterN (-1))) -- Decrement the number of windows in the master area
  , ("M-S-C-<Del>", io (exitWith ExitSuccess)) -- Quit xmonad
  , ("M-C-c", spawn "xmonad --recompile; killall xmobar; xmonad --restart") -- Recompile and restart xmonad
  , ("M-S-/", spawn ("echo \"" ++ help ++ "\" | xmessage -file -")) -- Run xmesssage with a summary of the default keybindings (useful for beginners)
  -- TODO Figure out how to do shortcuts where you switch to a workspace or move a window to another workspace
  ]
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
-- Add avoidStruts to prevent hiding of xmobar behind windows
-- https://xiangji.me/2018/11/19/my-xmonad-configuration/#tabbed-xmonadlayouttabbed for tab config
-- Tab config from https://gitlab.com/dwt1/dotfiles/-/blob/master/.xmonad/xmonad.hs
tabConfig = def {
  fontName = "xft:SauceCodePro Nerd Font Mono:pixelsize=15:antialias=true:hinting=true"
  , activeColor         = "#46d9ff"
  , inactiveColor       = "#313846"
  , activeTextColor     = "#282c34"
  , inactiveTextColor   = "#d0d0d0"
}
myLayout =
  (smartBorders $ avoidStruts $ spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $ emptyBSP) |||
  (smartBorders $ avoidStruts $ spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $ tiled) |||
  --(smartBorders $ avoidStruts $ spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $ spiral (6/7)) |||
  --(windowNavigation $ smartBorders $ avoidStruts $ spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $ Grid)  |||
  (avoidStruts $ smartBorders $ noBorders $ tabbed shrinkText tabConfig) ||| -- Added smartBorders because full screen windows have a border for some reason (may not need noBorders)
  (noBorders $ Full)
  where

     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
-- Copied from
------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
-- Managespawn needed to spawn windows on specific workspaces
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    ] <+> manageSpawn

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
-- Changed return () to spawnOnce with programs (mjd119)
myStartupHook = do
  spawnOnce "nm-applet &"
  spawnOnce "~/.fehbg &"
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
  spawnOnce "picom -b --experimental-backends &"
  spawnOnce "flameshot &"
  spawnOnce "$HOME/.config/udiskie/launch.sh &"
  --spawnOnce "trayer --edge top --align right --widthtype 30 --padding 0 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 &" -- Coped from dt gitlab
  spawnOnOnce "4" "radeon-profile &"
  spawnOnOnce "3" "thunar &"
  spawnOnOnce "2" "terminator &"
  spawnOnOnce "1" "emacs &"
  spawnOnOnce "1" "firefox &"
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
-- Added do, xmproc, $ docks ... (mjd119)
-- Ewmh is to allow rofi window switcher functionality
main = do
  xmproc <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc"
  xmonad $ docks $ ewmh def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
--        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = dynamicLogWithPP $ def {
            ppOutput = hPutStrLn xmproc
        },
        startupHook        = myStartupHook
    } `additionalKeysP` myEmacsKeys  -- Include emacs-like keybindings

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
-- Commented out for simplicity (definitions in main variable which starts xmonad)
--defaults = def {
--      -- simple stuff
--        terminal           = myTerminal,
--        focusFollowsMouse  = myFocusFollowsMouse,
--        clickJustFocuses   = myClickJustFocuses,
--        borderWidth        = myBorderWidth,
--        modMask            = myModMask,
--        workspaces         = myWorkspaces,
--        normalBorderColor  = myNormalBorderColor,
--        focusedBorderColor = myFocusedBorderColor,
--
--      -- key bindings
--        keys               = myKeys,
--        mouseBindings      = myMouseBindings,
--
--      -- hooks, layouts
--        layoutHook         = myLayout,
--        manageHook         = myManageHook,
--        handleEventHook    = myEventHook,
--        logHook            = myLogHook,
--        startupHook        = myStartupHook
--    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
