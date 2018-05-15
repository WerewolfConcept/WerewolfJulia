workspace()


abstract type Event end
struct WakeUpEvent{T} <: Event
    p::PlayerInstance
end
struct MultiWakeUpEvent{T} <: Event
    ps::Vector{PlayerInstance}
end

abstract type Skill end
abstract type Role <: Skill end
struct Junkie{T<:Skill} end
play(s::Junkie{T}, args...) where T<:Skill = play(T(), args...)
let pCounter = 0
    struct PlayerInstance
        gameInstance::GameInstance
        playerName::String
        playerID::Int
        skills::Vector{Skill}
        log::Vector{String}
        function PlayerInstance(gi::GameInstance, pName::String)
            return new(gi, pName, pCounter+=1, Vector{Skill}(), Vector{String}())
        end
    end
end

canPlay(p::PlayerInstance) = true
getPlayerName(pi::PlayerInstance) = pi.player.name
getSkills(pi::PlayerInstance) = pi.skills

function logEvent(pi::Union{PlayerInstance, GameInstance}, s::String)
    push!(pi.log, s)
end

struct Game
    roles::Vector{Role}
end

struct GameInstance
    game::Game
    playerSetup::Dict{Player, PlayerInstance}
    skillTags::Dict{Skill, Any}
    skillMatchings::Dict{Skill, Vector{PlayerInstance}}
    skillSchedulePlan::Vector{Skill}
    nightSchedule::Vector{Event}
    log::Vector{String}
end

function setSkill(gi::GameInstance, p::PlayerInstance, r::Skill)
    push!(get!(gi.skillMatchings, r, Vector{PlayerInstance}()), p)
    push!(p.skills, r)
end

function startNight(gi::GameInstance)
    foreach(x->prepareNightSchedule!(gi, x), gi.skillSchedulePlan)
end

prepareNightSchedule!(gi::GameInstance, r::T) where T<:Skill = append!(gi.nightSchedule, prepareNightSchedule(gi, r))


function requestInput(pi::PlayerInstance, s::String, T::DataType)
    println(s)
    while true
        try
            findPlayer
            return parse(T, readline())
        catch
            println("Invalid type: expected $T; Try again!")
        end
    end
end
