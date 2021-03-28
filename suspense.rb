STEP = 0.15

add_volume = 1

pong_hash = {}
define :ping_pong do |index_name, from_value, to_value, increase_value|
  is_reverse = false
  value = 0
  
  if pong_hash.key?(index_name)
    is_reverse = pong_hash[index_name][:is_reverse]
    value = pong_hash[index_name][:value]
  end
  
  if value == from_value
    is_reverse = false
  end
  
  if value == to_value
    is_reverse = true
  end
  
  if value < from_value
    value = from_value
  end
  
  if value > to_value
    value = to_value
  end
  
  if is_reverse
    value = [value - increase_value, from_value].max
  else
    value = [value + increase_value, to_value].min
  end
  
  pong_hash[index_name] = {
    :is_reverse => is_reverse,
    :value => value
  }
  
  return value
end

live_loop :test do
  synth :bnoise, note: (octs :c1, 4).tick + 5, release: 0.05, amp: add_volume, cutoff: ping_pong(:noise, 30, 120, 1)
  sleep(STEP)
end

live_loop :test2 do
  sample :glitch_bass_g, onset: pick, sustain: 0, release: 0.1, amp: add_volume + 2
  sleep(STEP)
end

live_loop :test3 do
  with_fx :reverb, mix: ping_pong(:mix, 0, 0.6, 0.01), room: 1 do
    sample :guit_em9, onset: pick, sustain: 0, release: 0.2, cutoff: ping_pong(:test, 50, 100, 1), amp: add_volume + 2
  end
  sleep(STEP)
end