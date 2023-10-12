-- Consts
local STICK_SELECT = {'Movement', 'Camera', 'Gyro'};
local MODID_SELECT = {'SHIFT', 'CTRL', 'ALT'};
local MODID_EXTEND = {'SHIFT', 'CTRL', 'ALT', 'CTRL-SHIFT', 'ALT-SHIFT', 'ALT-CTRL'};
local ADVANCED_OPT = RED_FONT_COLOR:WrapTextInColorCode(ADVANCED_OPTIONS);
local BINDINGS_OPT = KEY_BINDINGS_MAC or 'Bindings';

-- Helpers
local BLUE = GenerateClosure(ColorMixin.WrapTextInColorCode, BLUE_FONT_COLOR)
local unpack, _, db = unpack, ...; db('Data')();
do local s,h=0;_=function(v)if type(v)=='string'then h=v;s=0;else s=s+1;v.sort=s;v.head=h;return v end end end
------------------------------------------------------------------------------------------------------------
-- Default cvar data (global)
------------------------------------------------------------------------------------------------------------
db:Register('Variables', {
	showAdvancedSettings = {Bool(false);
		name = 'All Settings';
		desc = 'Display all available settings.';
		hide = true;
	};
	useCharacterSettings = {Bool(false);
		name = 'Character Specific';
		desc = 'Use character specific settings for this character.';
		hide = true;
	};
	--------------------------------------------------------------------------------------------------------
	_'Crosshair';
	--------------------------------------------------------------------------------------------------------
	crosshairEnable = _({Bool(true);
		name = 'Enable';
		desc = 'Enables a crosshair to reveal your hidden center cursor position at all times.';
		note = 'Use together with [@cursor] macros to place reticle spells in a single click.';
	});
	crosshairSizeX = _({Number(24, 1, true);
		name = 'Width';
		desc = 'Width of the crosshair, in scaled pixel units.';
		advd = true;
	});
	crosshairSizeY = _({Number(24, 1, true);
		name = 'Height';
		desc = 'Height of the crosshair, in scaled pixel units.';
		advd = true;
	});
	crosshairCenter = _({Number(0.2, 0.05, true);
		name = 'Center Gap';
		desc = 'Center gap, as fraction of overall crosshair size.';
		advd = true;
	});
	crosshairThickness = _({Number(2, 0.025, true);
		name = 'Thickness';
		desc = 'Thickness in scaled pixel units.';
		note = 'Value below two may appear interlaced or not at all.';
		advd = true;
	});
	crosshairColor = _({Color('ff00fcff');
		name = 'Color';
		desc = 'Color of the crosshair.';
	});
	--------------------------------------------------------------------------------------------------------
	_( MOUSE_LABEL ); -- Mouse
	--------------------------------------------------------------------------------------------------------
	mouseHandlingEnabled = _({Bool(true);
		name = 'Enable Mouse Handling';
		desc = 'Enable custom mouse handling, automating cursor toggling and timeout while using left and right mouse button emulation.';
		note = 'While disabled, cursor timeout, and toggling between free-roaming and center-fixed cursor are also disabled.';
		advd = true;
	});
	mouseHandlingReversed = _({Bool(false);
		name = 'Reverse Mouse Handling';
		desc = 'Left mouse button emulation toggles center-fixed mode instead of free-roaming mode. Right mouse button emulation toggles free-roaming mode instead of center-fixed mode.',
		note = 'Combine with '..BLUE(INTERACT_ON_LEFT_CLICK_TEXT)..' to make left click work similarly to right click without risk of unwanted combat engagements.',
		advd = true;
	});
	mouseFreeCursorReticle = _({Map(0, {[0] = OFF, [1] = VIDEO_OPTIONS_ENABLED, [2] = TARGET});
		name = 'Cursor Reticle Targeting';
		desc = 'Reticle targeting uses free cursor instead of staying center-fixed.';
		note = 'Reticle targeting means anything you place on the ground.';
	});
	mouseHideCursorOnMovement = _({Bool(false);
		name = 'Hide Cursor On Movement';
		desc = 'Cursor hides when you start moving, if free of obstacles.';
		note = 'Requires Settings > Hide Cursor on Stick Input set to None.';
	});
	mouseAlwaysCentered = _({Bool(false);
		name = 'Always Show Mouse Cursor';
		desc = 'Always keep cursor centered and visible when controlling camera.';
	});
	mouseShowCenterTooltip = _({Bool(true);
		name = 'Show Centered Cursor Tooltip';
		desc = 'Show tooltip for mouseover targets when cursor is centered.';
	});
	mouseAutoControlPickup = _({Bool(true);
		name = 'Automatically Control Cursor Pickups';
		desc = 'Automatically control cursor when picking up items.';
		advc = true;
	});
	mouseAutoClearCenter = _({Number(2.0, 0.25, true);
		name = 'Automatic Cursor Timeout';
		desc = 'Time in seconds to automatically hide centered cursor.';
		advd = true;
	});
	mouseFreeCursorEnableTime = _({Number(0.15, 0.05, true);
		name = 'Free Cursor Timein';
		desc = 'Time in seconds to enable free cursor.';
		note = 'Needs to be long enough to press and release the button.';
		advd = true;
	});
	doubleTapTimeout = _({Number(0.25, 0.05, true);
		name = 'Double Tap Timeframe';
		desc = 'Timeframe to toggle the mouse cursor when double-tapping a selected modifier.';
		advd = true;
	});
	doubleTapModifier = _({Select('<none>', '<none>', unpack(MODID_SELECT));
		name = 'Double Tap Modifier';
		desc = 'Which modifier to use to toggle the mouse cursor when double-tapped.';
	});
	--------------------------------------------------------------------------------------------------------
	_'Radial Menus';
	--------------------------------------------------------------------------------------------------------
	radialStickySelect = _({Bool(false);
		name = 'Sticky Selection';
		desc = 'Selecting an item on a ring will stick until another item is chosen.';
	});
	radialClearFocusTime = _({Number(0.5, 0.025);
		name = 'Focus Timeout';
		desc = 'Time to clear focus after intercepting stick input, in seconds.';
	});
	radialScale = _({Number(1, 0.025, true);
		name = 'Ring Scale';
		desc = 'Scale of all radial menus, relative to UI scale.';
		advd = true;
	});
	radialPreferredSize = _({Number(500, 25, true);
		name = 'Ring Size';
		desc = 'Preferred size of radial menus, in pixels.';
		advd = true;
	});
	radialActionDeadzone = _({Range(0.5, 0.05, 0, 1);
		name = 'Deadzone';
		desc = 'Deadzone for simple point-to-select rings.';
	});
	radialCosineDelta = _({Delta(1);
		name = 'Axis Interpretation';
		desc = 'Correlation between stick position and pie selection.';
		note = '+ Normal\n- Inverted';
		advd = true;
	});
	radialPrimaryStick = _({Select('Movement', unpack(STICK_SELECT));
		name = 'Primary Stick';
		desc = 'Stick to use for main radial actions.';
		note = 'Make sure your choice does not conflict with your bindings.';
	});
	radialRemoveButton = _({Button('PADRSHOULDER');
		name = 'Remove Button';
		desc = 'Button used to remove a selected item from an editable ring.';
	});
	--------------------------------------------------------------------------------------------------------
	_'Radial Keyboard';
	--------------------------------------------------------------------------------------------------------
	keyboardEnable = _({Bool(false);
		name = 'Enable';
		desc = 'Enables a radial on-screen keyboard that can be used to type messages.';
	});
	--------------------------------------------------------------------------------------------------------
	_'Raid Cursor';
	--------------------------------------------------------------------------------------------------------
	raidCursorScale = _({Number(1, 0.1);
		name = 'Scale';
		desc = 'Scale of the cursor.';
	});
	raidCursorMode = _({Map(1, {'Redirect', FOCUS, TARGET}),
		name = 'Targeting Mode';
		desc = 'Change how the raid cursor acquires a target. Redirect and focus modes will reroute appropriate spells without changing your target.';
		note = 'Basic redirect cannot route macros or ambiguous spells. Use target mode or focus mode with [@focus] macros to control behavior.';
	});
	raidCursorModifier = _({Select('<none>', '<none>', unpack(MODID_EXTEND));
		name = 'Modifier';
		desc = 'Which modifier to use with the movement buttons to move the cursor.';
		note = 'The bindings underlying the button combinations will be unavailable while the cursor is in use.\n\nModifier can also be configured on a per button basis.';
	});
	raidCursorUp = _({Button('PADDUP', true);
		name = 'Move Up';
		desc = 'Button to move the cursor up.';
		advd = true;
	});
	raidCursorDown = _({Button('PADDDOWN', true);
		name = 'Move Down';
		desc = 'Button to move the cursor down.';
		advd = true;
	});
	raidCursorLeft = _({Button('PADDLEFT', true);
		name = 'Move Left';
		desc = 'Button to move the cursor left.';
		advd = true;
	});
	raidCursorRight = _({Button('PADDRIGHT', true);
		name = 'Move Right';
		desc = 'Button to move the cursor right.';
		advd = true;
	});
	raidCursorFilter = _({String(nil);
		name = 'Filter Condition';
		desc = 'Filter condition to find raid cursor frames.';
		note = BLUE'node' .. ' is the current frame under scrutinization.';
		advd = true;
	});
	raidCursorWrapDisable = _({Bool(false);
		name = 'Disable Wrapping';
		desc = 'Prevent the cursor from wrapping when navigating.';
		advd = true;
	});
	--------------------------------------------------------------------------------------------------------
	_'Interface Cursor';
	--------------------------------------------------------------------------------------------------------
	UIenableCursor = _({Bool(true);
		name = ENABLE;
		desc = 'Enable interface cursor. Disable to use mouse-based interface interaction.';
	});
	UIpointerDefaultIcon = _({Bool(true);
		name = 'Show Default Button';
		desc = 'Show the default mouse action button.';
		advd = true;
	});
	UIpointerAnimation = _({Bool(true);
		name = 'Enable Animation';
		desc = 'Pointer arrow rotates in the direction of travel.';
		advd = true;
	});
	UIaccessUnlimited = _({Bool(false);
		name = 'Unlimited Navigation';
		desc = 'Allow cursor to interact with the entire interface, not only panels.';
		note = 'Combine with use on demand for full cursor control.';
		advd = true;
	});
	UIshowOnDemand = _({Bool(false);
		name = 'Use On Demand';
		desc = 'Cursor appears on demand, instead of in response to a panel showing up.';
		note = 'Requires Toggle Interface Cursor binding & Unlimited Navigation to use the cursor.';
		advd = true;
	});
	UIholdRepeatDisable = _({Bool(false);
		name = 'Disable Repeated Movement';
		desc = 'Disable repeated cursor movements - each click will only move the cursor once.';
	});
	UIholdRepeatDelay = _({Number(.125, 0.025);
		name = 'Repeated Movement Delay';
		desc = 'Delay until a movement is repeated, when holding down a direction, in seconds.';
		advd = true;
	});
	UIleaveCombatDelay = _({Number(0.5, 0.1);
		name = 'Reactivation Delay';
		desc = 'Delay before reactivating interface cursor after leaving combat, in seconds.';
		advd = true;
	});
	UIpointerSize = _({Number(22, 2, true);
		name = 'Pointer Size';
		desc = 'Size of pointer arrow, in pixels.';
		advd = true;
	});
	UIpointerOffset = _({Number(-2, 1);
		name = 'Pointer Offset';
		desc = 'Offset of pointer arrow, from the selected node center, in pixels.';
		advd = true;
	});
	UItravelTime = _({Range(4, 1, 1, 10);
		name = 'Travel Time';
		desc = 'How long the cursor should take to transition from one node to another.';
		note = 'Higher is slower.';
		advd = true;
	});
	UICursorLeftClick = _({Button('PAD1');
		name = KEY_BUTTON1;
		desc = 'Button to replicate left click. This is the primary interface action.';
		note = 'While held down, can simulate dragging by clicking on the directional pad.';
	});
	UICursorRightClick = _({Button('PAD2');
		name = KEY_BUTTON2;
		desc = 'Button to replicate right click. This is the secondary interface action.';
		note = 'This button is necessary to use or sell an item directly from your bags.';
	});
	UICursorSpecial = _({Button('PAD4');
		name = 'Special Button';
		desc = 'Button to handle special actions, such as adding items to the utility ring.';
	});
	UImodifierCommands = _({Select('SHIFT', unpack(MODID_SELECT));
		name = 'Modifier';
		desc = 'Which modifier to use for modified commands';
		note = 'The modifier can be used to scroll together with the directional pad.';
		opts = MODID_SELECT;
	});
	UIWrapDisable = _({Bool(false);
		name = 'Disable Wrapping';
		desc = 'Prevent the cursor from wrapping when navigating.';
		advd = true;
	});
	--------------------------------------------------------------------------------------------------------
	_'Unit Hotkeys';
	--------------------------------------------------------------------------------------------------------
	unitHotkeyGhostMode = _({Bool(false);
		name = 'Always Show';
		desc = 'Hotkey prompts linger on unit frames after targeting.';
	});
	unitHotkeyIgnorePlayer = _({Bool(false);
		name = 'Ignore Player';
		desc = 'Always ignore player, regardless of unit pool.';
	});
	unitHotkeySize = _({Number(32, 1);
		name = 'Size';
		desc = 'Size of unit hotkeys, in pixels.';
	});
	unitHotkeyOffsetX = _({Number(0, 1, true);
		name = 'Horizontal Offset';
		desc = 'Horizontal offset of the hotkey prompt position, in pixels.';
		advd = true;
	});
	unitHotkeyOffsetY = _({Number(0, 1, true);
		name = 'Vertical Offset';
		desc = 'Vertical offset of the hotkey prompt position, in pixels.';
		advd = true;
	});
	unitHotkeyPool = _({String('party%d$;raid%d+$;player$');
		name = 'Unit Pool';
		desc = 'Match criteria for unit pool, each type separated by semicolon.';
		note = '$: end of match token\n+: matches multiple tokens\n%d: matches number';
		advd = true;
	});
	unitHotkeySet = _({Select('Dynamic', 'Dynamic', 'Left', 'Right');
		name = 'Button Set';
		desc = 'Which button set to use for unit hotkeys.';
		note = 'Dynamic will use the button set that does not conflict with your '..BLUE'L[Target Unit Frames (Hold)]'..' binding.';
	});
	--------------------------------------------------------------------------------------------------------
	_( ACCESSIBILITY_LABEL ); -- Accessibility
	--------------------------------------------------------------------------------------------------------
	autoExtra = _({Bool(true);
		name = 'Automatically Bind Extra Items';
		desc = 'Automatically add tracked quest items and extra spells to main utility ring.';
	});
	autoSellJunk = _({Bool(true);
		name = 'Automatically Sell Junk';
		desc = 'Automatically sell junk when interacting with a merchant.';
	});
	UIscale = _({Number(1, 0.025, true);
		name = 'Global Scale';
		desc = 'Scale of most ConsolePort frames, relative to UI scale.';
		note = 'Action bar is scaled separately.';
		advd = true;
	});
	--------------------------------------------------------------------------------------------------------
	_'Power Level';
	--------------------------------------------------------------------------------------------------------
	powerLevelShow = _({Bool(false);
		name = 'Show Gauge';
		desc = 'Display power level for the current active gamepad.';
		note = 'This will not work with Xbox controllers connected via bluetooth. The Xbox Adapter is required.';
	});
	powerLevelShowIcon = _({Bool(true);
		name = 'Show Type Icon';
		desc = 'Display icon next to the power level for the current active gamepad.';
		note = 'Types are PlayStation, Xbox, or Generic.';
	});
	powerLevelShowText = _({Bool(true);
		name = 'Show Status Text';
		desc = 'Display power level status text for the current active gamepad.';
		note = 'Critical, Low, Medium, High, Wired/Charging, or Unknown/Disconnected.';
	});
	--------------------------------------------------------------------------------------------------------
	_( BINDINGS_OPT ); -- Bindings
	--------------------------------------------------------------------------------------------------------
	bindingOverlapEnable = _({Bool(false);
		name = 'Allow Binding Overlap';
		desc = 'Allow binding multiple combos to the same binding.';
		advd = true;
	});
	bindingAllowSticks = _({Bool(false);
		name = 'Allow Radial Bindings';
		desc = 'Allow binding discrete radial stick inputs.';
		advd = true;
	});
	bindingShowExtraBars = _({Bool(false);
		name = 'Show All Action Bars';
		desc = 'Show bonus bar configuration for characters without stances.';
		advd = true;
	});
	bindingDisableQuickAssign = _({Bool(false);
		name = 'Disable Quick Assign';
		desc = 'Disables quick assign for unbound combinations when using the gamepad action bar.';
		note = 'Requires reload.';
		advd = true;
	});
	disableHotkeyRendering = _({Bool(false);
		name = 'Disable Hotkey Rendering';
		desc = 'Disables customization to hotkeys on regular action bar.';
		advd = true;
	});
	useAtlasIcons = _({Bool(not CPAPI.IsClassicEraVersion);
		name = 'Use Default Hotkey Icons';
		desc = 'Uses the default hotkey icons instead of the custom icons provided by ConsolePort.';
		note = 'Requires reload.';
		hide = CPAPI.IsClassicEraVersion;
	});
	emulatePADPADDLE1 = _({Pseudokey('none');
		name = 'Emulate '..(KEY_PADPADDLE1 or 'Paddle 1');
		desc = 'Keyboard button to emulate the paddle 1 button.';
	});
	emulatePADPADDLE2 = _({Pseudokey('none');
		name = 'Emulate '..(KEY_PADPADDLE2 or 'Paddle 2');
		desc = 'Keyboard button to emulate the paddle 2 button.';
	});
	emulatePADPADDLE3 = _({Pseudokey('none');
		name = 'Emulate '..(KEY_PADPADDLE3 or 'Paddle 3');
		desc = 'Keyboard button to emulate the paddle 3 button.';
	});
	emulatePADPADDLE4 = _({Pseudokey('none');
		name = 'Emulate '..(KEY_PADPADDLE4 or 'Paddle 4');
		desc = 'Keyboard button to emulate the paddle 4 button.';
	});
	interactButton = _({Button('PAD1', true):Set('none', true);
		name = 'Click Override Button';
		desc = 'Button or combination used to click when a given condition applies, but act as a normal binding otherwise.';
		note = 'Use a shoulder button combined with crosshair for smooth and precise interactions. The click is performed at crosshair or cursor location.';
	});
	interactCondition = _({String('[vehicleui] nil; [@target,noharm][@target,noexists][@target,harm,dead] TURNORACTION; nil');
		name = 'Click Override Condition';
		desc = 'Macro condition to enable the click override button. The default condition clicks right mouse button when there is no enemy target.';
		note = 'Takes the format of...\n'
			.. BLUE'[condition] bindingID; nil'
			.. '\n...where each condition/binding is separated by a semicolon, and "nil" clears the override.';
		advd = true;
	});
	--------------------------------------------------------------------------------------------------------
	_( ADVANCED_OPT ); -- Advanced
	--------------------------------------------------------------------------------------------------------
	actionPageCondition = _({String(nil);
		name = 'Action Page Condition';
		desc = 'Macro condition to evaluate action bar page.';
		advd = true;
	});
	actionPageResponse = _({String(nil);
		name = 'Action Page Response';
		desc = 'Response to condition for custom processing.';
		advd = true;
	});
	classFileOverride = _({String(nil);
		name = 'Override Class File';
		desc = 'Override class theme for interface styling.';
		advd = true;
	});
})  --------------------------------------------------------------------------------------------------------
