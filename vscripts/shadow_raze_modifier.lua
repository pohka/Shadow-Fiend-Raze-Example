shadow_raze_modifier = class({})

function shadow_raze_modifier:IsDebuff()
	return true
end

function shadow_raze_modifier:GetMaxStacks() 
  return 4
end

function shadow_raze_modifier:OnRefresh()
  if self:GetStackCount() < self:GetMaxStacks() then
    self:IncrementStackCount()
  else
    self:SetStackCount( self:GetStackCount() )
  end
end

function shadow_raze_modifier:GetEffectName()
  return "particles/units/heroes/hero_nevermore/nevermore_shadowraze_debuff.vpcf"
end

function shadow_raze_modifier:GetTexture()
  return "nevermore_shadowraze1"
end
