if GameSetup == nil then
  GameSetup = class({})
end

--require("filters")
--require("constants")

--nil will not force a hero selection
local forceHero = "nevermore"

_G.USE_RELEASE_BUILD = false


function GameSetup:init()
  --=================================
  --DEBUG BUILD
  --=================================
  if IsInToolsMode() then
    --skip all the starting game mode stages e.g picking screen, showcase, etc
    GameRules:EnableCustomGameSetupAutoLaunch(true)
    GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    GameRules:SetHeroSelectionTime(10)
    GameRules:SetStrategyTime(0)
    GameRules:SetPreGameTime(0)
    GameRules:SetShowcaseTime(0)
    GameRules:SetPostGameTime(5)
    
    --disable some setting which are annoying then testing
    local GameMode = GameRules:GetGameModeEntity()
    GameMode:SetAnnouncerDisabled(true)
    GameMode:SetKillingSpreeAnnouncerDisabled(true)
    GameMode:SetDaynightCycleDisabled(true)
    GameMode:DisableHudFlip(true)
    GameMode:SetDeathOverlayDisabled(true)
    GameMode:SetWeatherEffectsDisabled(true)

    -- --disable music events
    GameRules:SetCustomGameAllowHeroPickMusic(false)
    GameRules:SetCustomGameAllowMusicAtGameStart(false)
    GameRules:SetCustomGameAllowBattleMusic(false)

    --Filters:AddAll()

    --multiple players can pick the same hero
    GameRules:SetSameHeroSelectionEnabled(true)

    --disable default respawning and buyback
    GameRules:SetHeroRespawnEnabled(false)
    GameMode:SetBuybackEnabled(false)
    GameMode:SetFixedRespawnTime(1)

    --force single hero selection (optional)
    if forceHero ~= nil then
      GameMode:SetCustomGameForceHero(forceHero)
    end
    
    --listen to game state event
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(self, "OnStateChange"), self)

    --GameRules:SetUseUniversalShopMode(true)

    --disable shop
    GameMode:SetRecommendedItemsDisabled(true)
    GameMode:SetStashPurchasingDisabled(true)

    --disable FoW
    GameMode:SetFogOfWarDisabled(true)
    
  end
end



function GameSetup:OnStateChange()
  --random hero once we reach strategy phase
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
    GameSetup:RandomForNoHeroSelected()
  end
end

function GameSetup:RandomForNoHeroSelected()
    --NOTE: GameRules state must be in HERO_SELECTION or STRATEGY_TIME to pick heroes
    --loop through each player on every team and random a hero if they haven't picked
  for teamNum = 2, 3 do
    for i=1, 5 do
      local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
      if PlayerResource:IsValidPlayerID(playerID) then
        if not PlayerResource:HasSelectedHero(playerID) then
          local hPlayer = PlayerResource:GetPlayer(playerID)
          if hPlayer ~= nil then
            hPlayer:MakeRandomHeroSelection()
          end
        end
      end
    end
  end
end