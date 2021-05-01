--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
import XMonad
import Data.Monoid
import System.Exit
import XMonad.Hooks.ManageDocks -- Import so xmobar is not behind windows
import XMonad.Util.SpawnOnce -- Import for spawnOnce command (mjd119)
import XMonad.Util.Run -- Import for spawnPipe (mjd119)
import XMonad.Hooks.DynamicLog -- Import to display statusbar information for xmobar
--import XMonad.Config.Desktop
import XMonad.Actions.SpawnOn -- Import to spawn programs on workspaces (post-compile or on startup)
import XMonad.Util.EZConfig -- Import to create keyboard shortcuts with emacs-like keybinding syntax
import XMonad.Layout.SubLayouts -- Import needed for creating sublayouts
import XMonad.Layout.Simplest -- Import to be used with tabbed sublayout
-- import XMonad.Layout.Groups
-- import XMonad.Layout.Gaps -- Don't need at the moment
-- import XMonad.Layout.Fullscreen -- Import for proper full screen support
import XMonad.Layout.Tabbed -- Import for tabbed layout (mjd119)
import XMonad.Layout.Spacing -- Import for gaps around windows
import XMonad.Layout.Grid -- Import for grid layout
import XMonad.Layout.NoBorders -- Import for smartBorders (no border when there is 1 window)
import XMonad.Layout.Spiral -- Import for spiral layout (like bspwm's spiral and autotiling for i3)
import XMonad.Hooks.EwmhDesktops -- Import to allow rofi window switcher functionality
import XMonad.Layout.BinarySpacePartition as BSP -- Import for BSP layout
import XMonad.Layout.WindowNavigation as WN -- Import to allow window navigation with keys (directional)
import XMonad.Layout.PerWorkspace -- Import to have specific layouts for each workspace
import XMonad.Layout.ToggleLayouts -- Import to toggle layouts (e.g. enable full screen)
import XMonad.Layout.Renamed -- Import to rename layouts
import XMonad.Layout.SimpleFloat -- Import for floating layout
import XMonad.Layout.SimplestFloat -- Import for floating layout (without decoration)
import XMonad.Layout.Accordion -- Import for accordion layout (non-focused windows in ribbons at the top+bottom of the screen)
-- import XMonad.Layout.Dishes -- Import for Dishes layout (stacks extra windows underneath the master windows)
-- import XMonad.Layout.Roledex -- Import for Roledex layout
-- import XMonad.Layout.TwoPane -- Import for TwoPane layout (left window is master and right is focused or second in layout order)
-- import XMonad.Layout.CenteredMaster -- Import for centerMaster layout (master window at center)
-- import XMonad.Layout.BinaryColumn -- Import for BinaryColumn layout (all windows in 1 column)
import XMonad.Layout.IfMax -- Import for IfMax Layout (switch to another layout if greater than N windows)
import XMonad.Hooks.RefocusLast -- Import to refocus most recent window (fix file dialog issue)
import XMonad.Hooks.Place -- Import to control placement of floating windows on the screen
import XMonad.Hooks.InsertPosition -- Import to control where new windows are placed
import XMonad.Hooks.ManageHelpers -- Import to specify hooks to fire if not caught by earlier ones (isDialog fix) from https://wiki.haskell.org/Xmonad/Frequently_asked_questions
import XMonad.Actions.CycleWS -- Import to cycle through workspaces
import XMonad.Actions.WithAll -- Import to kill all windows on current workspace
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
myBorderWidth   = 0 -- Was 1 (mjd119)
myTabBorderWidth = 0 -- Added by mjd119 to prevent ugly sublayout tab heading borders

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
-- Key bindings. Add, modify or remove key bindings here. (only ones I could not figure out using EZConfig are here)
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [
    --  Reset the layouts on the current workspace to default (mjd119 changed to y instead of space)
    ((modm .|. shiftMask, xK_y ), setLayout $ XMonad.layoutHook conf)
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
  , ("M-e", spawn "Thunar") -- Spawn Thunar File Manager window
  , ("M-b", spawn "firefox") -- Spawn firefox window
  , ("M-;", spawn "emacsclient -c -a 'emacs'") -- Launch emacs (-a creates emacs instance if one doesn't already exist)
  , ("M-d", spawn "rofi -show drun -show-icons -icon-theme Flat-Remix-Blue") -- Rofi run program
  , ("M-S-d", spawn "rofi -show window -show-icons -icon-theme Flat-Remix-Blue") -- Rofi window switcher
  , ("M-C-d", spawn "rofi -show run -show-icons -icon-theme Flat-Remix-Blue") --  Rofi run shell command
  , ("<Print>", spawn "flameshot gui") -- Take a partial screenshot
  , ("S-<Print>", spawn "flameshot full --path ~/Pictures/Screenshots/") -- Take a full screenshot
  , ("M-S-p", spawn "mpc toggle") -- Play/Pause Music Player Daemon
  , ("M-S-b", spawn "mpc seek -1%")
  , ("M-S-x", spawn "betterlockscreen -l dim") -- Lock screen
--  , ("M-p", spawn "dmenu_run") -- Open dmenu to open program
  , ("M-C-c", spawn "xmonad --recompile; killall xmobar trayer; xmonad --restart") -- Recompile and restart xmonad
  , ("M-S-C-<Delete>", io (exitWith ExitSuccess)) -- Quit xmonad
    -- Enable 2 dimensional movement (doesn't work with layouts with master window); window navigation not enabled currently
    -- Vim keybindings
  , ("M-l", sendMessage $ WN.Go R)
  , ("M-h", sendMessage $ WN.Go L)
  , ("M-k", sendMessage $ WN.Go U)
  , ("M-j", sendMessage $ WN.Go D)
  , ("M-S-l", sendMessage $ WN.Swap R)
  , ("M-S-h", sendMessage $ WN.Swap L)
  , ("M-S-k", sendMessage $ WN.Swap U)
  , ("M-S-j", sendMessage $ WN.Swap D)
  -- Keybindings for sublayouts (tabbed groups) [sourced from dt dotfiles gitlab]
  , ("M-C-h", sendMessage $ pullGroup L)
  , ("M-C-l", sendMessage $ pullGroup R)
  , ("M-C-k", sendMessage $ pullGroup U)
  , ("M-C-j", sendMessage $ pullGroup D)
  , ("M-C-m", withFocused (sendMessage . MergeAll))
  , ("M-C-u", withFocused (sendMessage . UnMerge))
  , ("M-C-/", withFocused (sendMessage . UnMergeAll))
  -- Change focus
  , ("M-C-,", onGroup W.focusUp')    -- Switch focus to next tab (only works in tabbed sublayout)
  , ("M-C-.", onGroup W.focusDown')  -- Switch focus to prev tab (only works in tabbed sublayout)
  , ("M-<Tab>", windows W.focusDown) -- Move focus to the next window (works on tabs)
  , ("M-S-<Tab>", windows W.focusUp) -- Move focus to the previous windows (works on tabs)
  -- Swap windows
  , ("C-M1-<Tab>", windows W.swapDown) -- Swap the focused window with the next window
  , ("C-S-M1-<Tab>", windows W.swapUp) -- Swap the focused window with the previous window
  -- Commands for layouts with a master window START --
  , ("M-m", windows W.focusMaster) -- Move focus to the master window
  , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
  , ("M--", sendMessage Shrink) -- Shrink the master area
  , ("M-=", sendMessage Expand) -- Expand the master area
  , ("M-,", sendMessage (IncMasterN 1)) -- Increment the number of windows in the master area
  , ("M-.", sendMessage (IncMasterN (-1))) -- Decrement the number of windows in the master area
  -- Commands for layouts with a master window END --
  -- Commands for BSP layout START --
    -- Vim keybindings
  , ("M-M1-h",    sendMessage $ ExpandTowards L)
  , ("M-M1-l",   sendMessage $ ShrinkFrom L)
  , ("M-M1-k",      sendMessage $ ExpandTowards U)
  , ("M-M1-j",    sendMessage $ ShrinkFrom U)
  , ("M-M1-C-h",  sendMessage $ ShrinkFrom R)
  , ("M-M1-C-l", sendMessage $ ExpandTowards R)
  , ("M-M1-C-k",    sendMessage $ ShrinkFrom D)
  , ("M-M1-C-j",  sendMessage $ ExpandTowards D)
    -- Alternate keybindings (directional keys)
  , ("M-M1-<Left>",    sendMessage $ ExpandTowards L)
  , ("M-M1-<Right>",   sendMessage $ ShrinkFrom L)
  , ("M-M1-<Up>",      sendMessage $ ExpandTowards U)
  , ("M-M1-<Down>",    sendMessage $ ShrinkFrom U)
  , ("M-M1-C-<Left>",  sendMessage $ ShrinkFrom R)
  , ("M-M1-C-<Right>", sendMessage $ ExpandTowards R)
  , ("M-M1-C-<Up>",    sendMessage $ ShrinkFrom D)
  , ("M-M1-C-<Down>",  sendMessage $ ExpandTowards D)
  , ("M-s",            sendMessage $ BSP.Swap)
  , ("M-M1-s",         sendMessage $ BSP.Rotate)
  -- Comamands for BSP layout END --
  -- Spacing (gaps commands)
  , ("M-g", decScreenWindowSpacing 2)
  , ("M-M1-g", incScreenWindowSpacing 2)
    -- Multiple commands with 1 keybinding (see https://superuser.com/a/570021)
  , ("M-M1-C-g", sequence_ [toggleScreenSpacingEnabled, toggleWindowSpacingEnabled])
  -- Toggle layout
  , ("M-f", sendMessage ToggleLayout)
  -- Miscellaneuous actions
  , ("M-S-q", kill) -- Kill focused window
  , ("M-S-C-q", killAll) -- Kill all windows on current workspace (found on dt gitlab dotfiles)
  , ("M-S-<Space>", sendMessage NextLayout) -- Go to the next layout algorithm (cycle)
  , ("M-r", refresh) -- Resize viewed windows to the correct size
  , ("M-t", withFocused $ windows . W.sink) -- Push window back into tiling mode
  -- TODO Figure out how to do shortcuts where you switch to a workspace or move a window to another workspace
--  , ("M-S-<Space>", setLayout $ XMonad.layoutHook conf) TODO Figure out how to convert from original
  , ("M-<Page_Down>", nextWS) -- Go to next workspace
  , ("M-<Page_Up>", prevWS) -- Go to previous workspace
  , ("M-S-<Page_Down>", shiftToNext) -- Shift focused window to next workspace
  , ("M-S-<Page_Up>", shiftToPrev) -- Shift focused window to previous workspace
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
  fontName = "xft:SauceCodePro Nerd Font Mono:size=9:antialias=true:hinting=true"
  , activeColor         = "#46d9ff"
  , inactiveColor       = "#313846"
  , activeTextColor     = "#282c34"
  , inactiveTextColor   = "#d0d0d0"
  -- TODO Figure out how to not apply borders to tabbed sublayout
  , activeBorderWidth   = 0
  , inactiveBorderWidth = 0
  , urgentBorderWidth   = 0
}
-- Sublayouts taken from dt dotfiles gitlab
-- TODO Figure out how to apply noBorders to only the sublayout windows and keep them for other windows (border looks ugly with tab group)
myLayout =
  refocusLastLayoutHook
  $ bsp
  ||| tabs
  ||| accordion

bsp =
  -- BSP layout
  (renamed [Replace "BSP"]
   $ toggleLayouts (noBorders Full)
   $ avoidStruts
   $ smartBorders
   $ windowNavigation
   $ addTabs shrinkText tabConfig
   $ subLayout [] (Simplest)
   -- Disable spacing between windows (previously all values were 10)
   $ spacingRaw False (Border 0 0 0 0) True (Border 0 0 0 0) True
   $ emptyBSP)
tall =
  -- Tall layout
  (renamed [Replace "Tall"]
   $ toggleLayouts (noBorders Full)
   $ avoidStruts
   $ smartBorders
   $ windowNavigation
   $ addTabs shrinkText tabConfig
   $ subLayout [] (Simplest)
   -- Disable spacing between windows (previously all values were 10)
   $ spacingRaw False (Border 0 0 0 0) True (Border 0 0 0 0) True
   $ tiled)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
grid =
  -- Grid layout
  (renamed [Replace "Grid"]
   $ toggleLayouts (noBorders Full)
   $ avoidStruts
   $ smartBorders
   $ windowNavigation
   $ addTabs shrinkText tabConfig
   $ subLayout [] (Simplest)
   -- Disable spacing between windows (previously all values were 10)
   $ spacingRaw False (Border 0 0 0 0) True (Border 0 0 0 0) True
   $ Grid)
tabs =
  -- Tabbed layout
  (renamed [Replace "Tabbed"] $ toggleLayouts (noBorders Full) $
   avoidStruts $ smartBorders $ tabbed shrinkText tabConfig)
  -- Added smartBorders because full screen windows have a border for some reason (may not need noBorders)
full =
  -- Fullscreen layout
  (noBorders Full)
accordion =
  -- Accordion layout
  (renamed [Replace "Accordion"]
   $ toggleLayouts (noBorders Full)
   $ avoidStruts
   $ noBorders
   $ windowNavigation
   $ IfMax 3 Accordion (tabbed shrinkText tabConfig))
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
-- TODO Figure out how to use insertPosition so spawned window is focused and vlc's dock pops up in full screen
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "Sxiv"           --> doCenterFloat
    , className =? "feh"            --> doCenterFloat
    , isDialog                      --> doCenterFloat
    , title =? "Quick Format Citation"  --> doCenterFloat -- For Zotero citation pop up
    , className =? "firefox" <&&> title =? "Library"  --> doCenterFloat -- For Firefox Downloads,History,Bookmarks window
    , className =? "firefox" <&&> resource =? "Dialog" --> doCenterFloat -- From dt dotfiles (float firefox dialog windows; might not need)
    -- May not need to handle fullscreen windows
    , isFullscreen                  --> doFullFloat
    ] <+> insertPosition Above Newer <+> manageDocks <+> manageSpawn <+> placeHook (simpleSmart)

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = fullscreenEventHook <+> refocusLastWhen (refocusingIsActive <||> isFloat)

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
  spawnOnce "imwheel -d -b 45"
  --spawnOnce "nm-applet &"
  spawnOnce "~/.fehbg &"
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
  spawnOnce "picom -b --experimental-backends &"
  spawnOnce "flameshot &"
  spawnOnce "$HOME/.config/udiskie/launch.sh &"
--spawnOnce "trayer --edge bottom --align center --widthtype request --padding 10 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 &" -- Copied from dt gitlab
-- See https://wiki.haskell.org/Xmonad/Config_archive/John_Goerzen%27s_Configuration for trayer
-- Not spawn once because I set my xmonad restart shortcut to recompile, kill and restart trayer, and restart xmonad
-- TODO Find solution to make trayer pitch black to blend in with xmobar
  spawn "trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand false --widthtype request --transparent false --height 24 &"
  spawnOnce "volumeicon &"
  spawnOnOnce "IV" "radeon-profile"
  spawnOnOnce "II" "terminator"
--  spawnOnOnce "III" "thunar &"
--  spawnOnOnce "I" "emacs &"
--  spawnOnOnce "I" "firefox &"
  spawnOnce "emacs --daemon &" -- Start emacs daemon on startup
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
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout, -- Add hook to make sure last focused window is remembered (don't refocus after floating window closed)
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = dynamicLogWithPP $ def {
            ppOutput = hPutStrLn xmproc
        },
        startupHook        = myStartupHook
    } `additionalKeysP` myEmacsKeys  -- Include emacs-like keybindings
