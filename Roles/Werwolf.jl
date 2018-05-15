struct Werewolf <: Role end

function play(::WakeUpEvent{Werewolf}, target::PlayerInstance)
    # logEvent(, "One wolf attacked "*getPlayerName(target))
    return target
end

function play(ev::MultiWakeUpEvent{Werewolf})

end

function prepareNightSchedule(gi::GameInstance, w::Werewolf)
    return MultiWakeUpEvent{Werewolf}(filter(canPlay, gi.skillMatchings[w]))
end

function seerGoodness(::Werewolf)
    return false
end
