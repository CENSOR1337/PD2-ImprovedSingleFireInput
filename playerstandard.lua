local origin__check_action_primary_attack = PlayerStandard._check_action_primary_attack
local bufferTime = 0

local function ShouldResetBuffer(self, weapon, input)
    if (input.btn_reload_press) then
        return
    end

    if (self:_is_reloading()) then
        return true
    end

    if (self:_changing_weapon()) then
        return true
    end

    if (self:_is_throwing_projectile()) then
        return true
    end

    if (self:_interacting()) then
        return true
    end

    if (self:_is_meleeing()) then
        return true
    end

    if (self:running() and not self._equipped_unit:base():run_and_shoot_allowed()) then
        return true
    end

    if (weapon and weapon:out_of_ammo()) then
        return true
    end

    return false
end

function PlayerStandard:_check_action_primary_attack(t, input)
    local weapon = self._equipped_unit:base()

    if (input.btn_primary_attack_press) then
        if self._equipped_unit then
            if (weapon and weapon:is_single_shot()) then
                local fireRate = weapon:weapon_fire_rate() / weapon:fire_rate_multiplier()
                bufferTime = t + (fireRate * 0.4)
            end
        end
    end

    local bufferActive = t < bufferTime

    if (bufferActive and ShouldResetBuffer(self, weapon, input)) then
        bufferActive = false
        bufferTime = 0
    end

    if (bufferActive) then
        input.btn_primary_attack_press = true
        input.btn_primary_attack_state = true
    end

    return origin__check_action_primary_attack(self, t, input)
end
