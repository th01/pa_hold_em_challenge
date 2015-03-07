module TexasHoldEm
  class << self

  def hand_ids(hand)
    conversion = {
      "2c"=>0, "2d"=>1, "2h"=>2, "2s"=>3, "3c"=>4, "3d"=>5, "3h"=>6, "3s"=>7, "4c"=>8,
      "4d"=>9, "4h"=>10, "4s"=>11, "5c"=>12, "5d"=>13, "5h"=>14, "5s"=>15, "6c"=>16,
      "6d"=>17, "6h"=>18, "6s"=>19, "7c"=>20, "7d"=>21, "7h"=>22, "7s"=>23, "8c"=>24,
      "8d"=>25, "8h"=>26, "8s"=>27, "9c"=>28, "9d"=>29, "9h"=>30, "9s"=>31, "Tc"=>32,
      "Td"=>33, "Th"=>34, "Ts"=>35, "Jc"=>36, "Jd"=>37, "Jh"=>38, "Js"=>39, "Qc"=>40,
      "Qd"=>41, "Qh"=>42, "Qs"=>43, "Kc"=>44, "Kd"=>45, "Kh"=>46, "Ks"=>47, "Ac"=>48,
      "Ad"=>49, "Ah"=>50, "As"=>51
    }
    hand.map {|card| conversion[card]}.sort.reverse
  end

  def hand_values(hand_ids)
    hand_ids.map { |id| id / 4 }
  end

  def hand_value_occurrences(hand_vals)
    hand_vals.each_with_object(Hash.new(0)) { |val, hash| hash[val] += 1 }
  end

  def hand_values_by_suit(hand_ids)
    hand_ids.each_with_object([[],[],[],[]]) { |id, arr| arr[id % 4] << id / 4 }
  end

  def of_a_kind(hand_vals)
    hand_val_occ = hand_value_occurrences(hand_vals)
    has_of_a_kind = hand_val_occ.values.select { |occ| occ > 1 }.reverse
    return false if has_of_a_kind.empty?
    case has_of_a_kind[0]
    when 4
      quads = hand_val_occ.key(4)
      hand_vals.delete(quads)
      return hand_vals.unshift(quads)[0..1]
    when 3
      trips = hand_val_occ.key(3)
      if has_of_a_kind[1] && has_of_a_kind[1] >= 2
        pair = hand_val_occ.key(2)
        return [trips, pair]
      else
        hand_vals.delete(trips)
        return hand_vals.unshift(trips)[0..2]
      end
    when 2
      pair = hand_val_occ.key(2)
      hand_vals.delete(pair)
      hand_val_occ.delete(pair)
      if has_of_a_kind[1] == 2
        second_pair = hand_val_occ.key(2)
        hand_vals.delete(second_pair)
        return hand_vals.unshift(second_pair).unshift(pair)[0..2]
      else
        return hand_vals.unshift(pair)[0..3]
      end
    end
  end

  def straight(hand_vals)
    prev, arr = nil, []
    hand_vals.push(-1) if hand_vals[0] == 12
    hand_vals.each do |val|
      return [val] if (((val-4)..val).to_a & hand_vals).length >= 5
    end
    false
  end

  def flush(hand_by_suit)
    hand_by_suit.each { |vals| return vals[0..4] if vals.length >= 5 }
    false
  end

  def straight_flush(hand_by_suit)
    return flush(hand_by_suit) ? straight(flush(hand_by_suit)) : false
  end

  private
  

  end
end
