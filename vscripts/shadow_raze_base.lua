shadow_raze_base = class({})

function shadow_raze_base:OnSpellStart(ability)
  local caster = ability:GetCaster()
  local direction = caster:GetForwardVector()
  local range = ability:GetSpecialValueFor("range")
  local origin = caster:GetAbsOrigin() + direction * range
  local radius = 250
  local damagePerStackValues = { 50, 60, 70, 80 }
  local level = ability:GetLevel()
  if level > #damagePerStackValues then
    level = #damagePerStackValues
  end
  local duration = 8.0

  --find units hit by raze
  local units = FindUnitsInRadius(
    caster:GetTeam(),
    origin,
    nil,
    radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_ALL,
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER,
    false
  )

  local baseDamage = 90
  local damagePerStack = damagePerStackValues[level]
  local modName = "shadow_raze_modifier"


  for _, unit in pairs(units) do
    --apply modifier first then do damage
    unit:AddNewModifier(caster, ability, modName, { duration = duration })

    --modifier count starts at zero
    local count = unit:GetModifierStackCount(modName, caster) + 1
    local damage = baseDamage + damagePerStack * count

    ApplyDamage({
      victim = unit,
      attacker = caster,
      damage = damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      damage_flags = DOTA_DAMAGE_FLAG_NONE,
      ability = ability
    })
  end

  --particle effect and sound
  local pID = ParticleManager:CreateParticle(
    "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf",
    PATTACH_CUSTOMORIGIN,
    caster
  )
  ParticleManager:SetParticleControl(pID, 0, origin)
  EmitSoundOnLocationWithCaster(origin, "Hero_Nevermore.Shadowraze", caster)
end