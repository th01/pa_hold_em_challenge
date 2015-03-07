require 'spec_helper'
require 'pry'

describe TexasHoldEm do

  before(:all) do
    @hand = [
      "2c", "2d", "2h", "2s", "3c", "3d", "3h", "3s", "4c", "4d", "4h", "4s",
      "5c", "5d", "5h", "5s", "6c", "6d", "6h", "6s", "7c", "7d", "7h", "7s",
      "8c", "8d", "8h", "8s", "9c", "9d", "9h", "9s", "Tc", "Td", "Th", "Ts",
      "Jc", "Jd", "Jh", "Js", "Qc", "Qd", "Qh", "Qs", "Kc", "Kd", "Kh", "Ks",
      "Ac", "Ad", "Ah", "As"
    ]
    @hand_ids = (0..51).to_a.reverse
    counter, @hand_values, @hand_by_suit = 0, [], []
    (0..51).step(4) { |i| 4.times { @hand_values.push(counter) }; counter += 1 }
    @hand_values = @hand_values.reverse
    4.times { @hand_by_suit.push((0..12).to_a.reverse) }
    @hand_values_by_suit = {
      12 => 4, 11 => 4, 10 => 4, 9 => 4, 8 => 4, 7 => 4,
      6 => 4, 5 => 4, 4 => 4, 3 => 4, 2 => 4, 1 => 4, 0 => 4
    }
    @high_card = [12,10,8,6,4,2]
    @pair = [12,11,9,7,5,3,3]
    @two_pair = [12,11,9,5,5,3,3]
    @three_of_a_kind = [12,11,9,7,3,3,3]
    @full_house = [12,11,7,7,3,3,3]
    @four_of_a_kind = [12,11,9,3,3,3,3]
    @straight = [12, 11, 10, 9, 8, 4, 0]
    @five_card_straight = [12, 11, 10, 9, 8]
    @five_high_stright = [12, 9, 6, 3, 2, 1, 0]
    @no_straight = [12, 9, 6, 4, 3, 2, 1]
    @flush = [[11,10,9,8,5],[],[5],[4]]
    @big_flush = [[12,11,9,8,7,5],[],[],[4]]
    @no_flush = [[7,5,4,3],[7],[2],[6]]
    @straight_flush = [[12,11,10,9,8],[],[5],[4]]
  end

  it 'can convert a hand array to an array of card ID values in decending order' do
    expect(TexasHoldEm.hand_ids(@hand)).to eq(@hand_ids)
  end

  it 'converts hand_ids to an array of hand_values' do
    expect(TexasHoldEm.hand_values(@hand_ids)).to eq(@hand_values)
  end

  it 'converts hand_ids to an array of arrays by suit' do
    expect(TexasHoldEm.hand_values_by_suit(@hand_ids)).to eq(@hand_by_suit)
  end

  it 'set a key of a hash to the value with a value of number of occurrences' do
    expect(TexasHoldEm.hand_value_occurrences(@hand_values)).to eq(@hand_values_by_suit)
  end

  it 'can detect any number of a kind in a given hand' do
    expect(TexasHoldEm.of_a_kind(@high_card)).to be(false)
    expect(TexasHoldEm.of_a_kind(@pair)).to eq([3,12,11,9])
    expect(TexasHoldEm.of_a_kind(@two_pair)).to eq([5,3,12])
    expect(TexasHoldEm.of_a_kind(@three_of_a_kind)).to eq([3,12,11])
    expect(TexasHoldEm.of_a_kind(@full_house)).to eq([3,7])
    expect(TexasHoldEm.of_a_kind(@four_of_a_kind)).to eq([3,12])
  end

  it 'can detect a straight and return an array containing the highest straight value' do
    expect(TexasHoldEm.straight(@straight)).to eq([12])
    expect(TexasHoldEm.straight(@five_card_straight)).to eq([12])
    expect(TexasHoldEm.straight(@five_high_stright)).to eq([3])
    expect(TexasHoldEm.straight(@no_straight)).to be(false)
  end

  it 'can detect a flush and return an array containing the highest 5 flush cards' do
    expect(TexasHoldEm.flush(@flush)).to eq([11,10,9,8,5])
    expect(TexasHoldEm.flush(@big_flush)).to eq([12, 11, 9, 8, 7])
    expect(TexasHoldEm.flush(@no_flush)).to be(false)
    expect(TexasHoldEm.flush(@straight_flush)).to eq([12,11,10,9,8])
  end

  it 'can detect a straight flush and return an array containing the highest straight flush value' do
    expect(TexasHoldEm.straight_flush(@flush)).to be(false)
    expect(TexasHoldEm.straight_flush(@big_flush)).to be(false)
    expect(TexasHoldEm.straight_flush(@no_flush)).to be(false)
    expect(TexasHoldEm.straight_flush(@straight_flush)).to eq([12])
  end

end
