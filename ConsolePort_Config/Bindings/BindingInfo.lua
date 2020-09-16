local db, _, env = ConsolePort:DB(), ...;
local BindingInfoMixin, BindingInfo = {}, {
	--------------------------------------------------------------
	BindingPrefix = 'BINDING_NAME_%s';
	HeaderPrefix  = 'BINDING_%s';
	NotBoundColor = '|cFF757575%s|r';
	DisplayFormat = '%s\n|cFF757575%s|r';
	--------------------------------------------------------------
	DictCounter = 0;
	Bindings  = {};
	Headers   = {};
	Actionbar = {};
	--------------------------------------------------------------
	ActionInfoHandlers = {
		spell        = function(id) return GetSpellInfo(id) or STAT_CATEGORY_SPELL end; -- Hack fallback: 'Spell'
		item         = function(id) return GetItemInfo(id) or HELPFRAME_ITEM_TITLE end; -- Hack fallback: 'Item'
		macro        = function(id) return GetActionText(id) and GetActionText(id) .. ' ('..MACRO..')' end;
		mount        = function(id) return C_MountJournal.GetMountInfoByID(id) end;
		flyout       = function(id) return GetFlyoutInfo(id) end;
		companion    = function() return COMPANIONS end; -- low-prio todo: get some info on whatever this is
		summonmount  = function() return MOUNT end;
		equipmentset = function() return BAG_FILTER_EQUIPMENT end;
	};
	--------------------------------------------------------------
}; env.BindingInfo, env.BindingInfoMixin = BindingInfo, BindingInfoMixin;

---------------------------------------------------------------
-- Action bar handling
---------------------------------------------------------------
function BindingInfo:GetActionButtonID(binding)
	return db(('Actionbar/Binding/%s'):format(binding))
end

function BindingInfo:GetActionbarBindings()
	self:RefreshDictionary()
	return self.Actionbar;
end

function BindingInfo:AddActionbarBinding(name, bindingID, actionID)
	self.Actionbar[actionID] = {name = name, binding = bindingID};
end

---------------------------------------------------------------
-- Dictionary
---------------------------------------------------------------
function BindingInfo:IsBindingMissingHeader(id)
	-- called for bindings where header could not be found, so check...
	return (id:match('^HEADER') and       -- (1) is it a header?
		not id:match('^HEADER_BLANK') and -- (2) ...that isn't blank?
		not id:match('^CP_')) or          -- (3) ...and doesn't belong to CP?
		not id:match('^HEADER')           -- (4) or is it not a header?
end

function BindingInfo:AddBindingToCategory(name, id, category)
	local bindings = self.Bindings;
	bindings[category] = bindings[category] or {};
	
	local category = bindings[category];
	category[#category+1] = {name = name, binding = id};
	return category;
end


function BindingInfo:RefreshDictionary()
	local numBindings = GetNumBindings()
	local isUpdatedDict = ( numBindings ~= self.DictCounter )
	-- only run refresh when bindings have been added
	if ( isUpdatedDict ) then
		local bindings, headers = self.Bindings, self.Headers;

		-- wipe all current bindings, indices may have changed
		wipe(bindings)
		wipe(headers)
		wipe(self.Actionbar)

		for i=1, numBindings do
			local id, header = GetBinding(i)

			-- link binding IDs to their headers
			headers[id] = header;

			-- NOTE: GetBindingName() is not reliable, use global
			-- Some bindings are actually subheaders or separators, and
			-- GetBindingName() can't be verified since it returns the
			-- original string if it doesn't find a match.
			local global = _G[self.BindingPrefix:format(id)]
			local name   = global or _G[self.HeaderPrefix:format(id)]
			local action = self:GetActionButtonID(id)

			if action then
				self:AddActionbarBinding(name, id, action)
			elseif header then
				-- add binding to its designated category table, omit binding index if not an actual binding
				local title = _G[header] or header;
				self:AddBindingToCategory(name, id, title)
			elseif self:IsBindingMissingHeader(id) then
				-- at this point, the binding definitely belongs in the "Other" category
				self:AddBindingToCategory(name, id, BINDING_HEADER_OTHER)
			end
		end
		self.DictCounter = numBindings;
		-- TODO: add custom bindings that we don't show in regular keybinding UI
		self:RenameActionbarCategory(bindings)
		self:AssertBindings(bindings)
	end
	return self.Bindings, self.Headers, isUpdatedDict;
end

---------------------------------------------------------------
-- Hacks
---------------------------------------------------------------
function BindingInfo:AssertBindings(bindings)
	-- HACK: trash any tables that don't have actual bindings, handling
	-- the quirk of the game's binding system listing separators
	-- in the UI as actual, legit bindings.
	for category, set in next, bindings do
		local gc = true;
		for i, data in ipairs(set) do
			if not data.binding:match('^HEADER_BLANK') then
				gc = false; break;
			end
		end
		if gc then
			bindings[category] = nil;
			category = nil;	
		end
	end
end

function BindingInfo:RenameActionbarCategory(bindings)
	-- HACK: rename misc action bar to "Action Bar (Miscellaneous)",
	-- so action bar can be handled separately in the binding manager.
	local newName = ('%s (%s)'):format(BINDING_HEADER_ACTIONBAR, MISCELLANEOUS)
	bindings[newName] = bindings[BINDING_HEADER_ACTIONBAR];
	bindings[BINDING_HEADER_ACTIONBAR] = nil;
end

---------------------------------------------------------------
-- Mixin for things that need formatted binding info
---------------------------------------------------------------
function BindingInfoMixin:GetBindingInfo(binding)
	if (not binding or binding == '') then return BindingInfo.NotBoundColor:format(NOT_BOUND) end;
	local bindings, headers = BindingInfo:RefreshDictionary()

	local text, name = _G[BindingInfo.BindingPrefix:format(binding)]
	local header = headers[binding];

	-- check if this is an action bar binding
	local actionID = BindingInfo:GetActionButtonID(binding)
	if actionID then
		-- swap the info for current bar if offset
		actionID = actionID <= NUM_ACTIONBAR_BUTTONS and
			actionID + ((db('Pager'):GetCurrentPage() - 1) * 12) or actionID;

		local texture = GetActionTexture(actionID)
		local kind, kindID, subKind = GetActionInfo(actionID)

		local getinfo = BindingInfo.ActionInfoHandlers[kind]
		if getinfo then
			name = getinfo(kindID)
		end

		if name then
			-- if action has a name, suffix the binding, omit the header,
			-- return the concatenated string and the action texture
			return BindingInfo.DisplayFormat:format(name, text), texture, actionID;
		elseif texture then
			-- no name found, but there's a texture.
			if text then
				name = header and _G[header]
				name = name and BindingInfo.DisplayFormat:format(text, name) or text;
			end
			return name, texture, actionID;
		end
	end
	if text then
		-- this binding does not have an action ID, just return the binding and header names
		name = header and _G[header];
		name = name and BindingInfo.DisplayFormat:format(text, name) or text;
		return name, nil, actionID;
	end
	-- at this point, this is not an usual binding. this is most likely a click binding.
	name = gsub(binding, '(.* ([^:]+).*)', '%2') -- upvalue so it doesn't return more than 1 arg
	name = name or BindingInfo.NotBoundColor:format(NOT_BOUND);
	return name, nil, actionID;
end