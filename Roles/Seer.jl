struct Seer <: Role end

function play(::Seer, target::PlayerInstance)
    logEvent(target, "Seer saw "*getPlayerName(target))
    return all(seerGoodness.(getSkills(target)))
end

function prepareNightSchedule(gi::GameInstance, w::Seer)
    return [WakeUpEvent{Seer}(p) for p in gi.skillMatchings[w] if canPlay(p)]
end

function seerGoodness(::Seer)
    return true
end

play(Seer(), PlayerInstance(Player(1,"Aaron")))

play(Junkie{Seer}(), PlayerInstance(Player(1,"Aaron")))
