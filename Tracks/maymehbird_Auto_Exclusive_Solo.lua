-- @description Auto Exclusive Solo (click S to replace previous solos)
-- @author maymehbird
-- @version 1.0.0
-- @changelog
--   Initial release.
-- @about
--   Run once as a background ReaScript. Clicking a previously unsoloed
--   track's S button will automatically unsolo tracks that were soloed before.
--   Works in both the track control panel (TCP) and mixer (MCP).
--   If several tracks become soloed in one operation, they are kept together.
--   Already-soloed tracks can still be turned off normally.
--   Safe-solo states (5 and 6) are left untouched.
--   No third-party extensions are required.

local prior = {}
local active_project = nil

local function snapshot(project)
  prior = {}
  for i = 0, reaper.CountTracks(project) - 1 do
    local track = reaper.GetTrack(project, i)
    prior[track] = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
  end
end

local function tick()
  local project = reaper.EnumProjects(-1, "")

  -- A new project tab should retain its existing solo states until a new solo.
  if project ~= active_project then
    active_project = project
    snapshot(project)
  else
    local now = {}
    local just_soloed = {}
    local has_new_solo = false

    for i = 0, reaper.CountTracks(project) - 1 do
      local track = reaper.GetTrack(project, i)
      local state = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
      now[track] = state

      -- 1: solo; 2: solo-in-place. 5/6 are safe-solo modes.
      if (state == 1 or state == 2) and (prior[track] or 0) == 0 then
        just_soloed[track] = true
        has_new_solo = true
      end
    end

    if has_new_solo then
      local changed = false
      for track, state in pairs(now) do
        -- Preserve the new solo(s) and leave safe-solo alone.
        if (state == 1 or state == 2) and not just_soloed[track] then
          reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 0)
          now[track] = 0
          changed = true
        end
      end
      if changed then
        reaper.TrackList_AdjustWindows(false)
        reaper.UpdateArrange()
      end
    end

    prior = now
  end

  reaper.defer(tick)
end

tick()
