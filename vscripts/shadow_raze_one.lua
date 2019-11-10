shadow_raze_one = class({})
LinkLuaModifier("shadow_raze_modifier", LUA_MODIFIER_MOTION_NONE)

require("shadow_raze_base")

function shadow_raze_one:OnSpellStart()
  shadow_raze_base:OnSpellStart(self)
end
