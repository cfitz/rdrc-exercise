#!/usr/bin/env ruby
require 'rubygems'

# Basic Deck of Cards Class
class Deck 
  
  attr_accessor :cards
  
  def initialize 
    @cards = initialize_cards
  end
  
  def deal 
    @cards.shift
  end
  
private  
  
  
  # this method returns an array of 52 randomly ordered card values
  def initialize_cards
    cards = []
    4.times { cards += (2..14).to_a }
    cards.sample(52)
  end
  
end #deck


class Hand
  attr_accessor :cards
  attr_accessor :deck
  
  def initialize(deck)
    @cards = []
    @deck = deck
  end
  
  def hit 
    @cards << @deck.deal
  end
  
  
end #hand 

class Dealer
  attr_accessor :deck
  attr_accessor :hand
  
  def initialize()
    @deck = Deck.new
    @hand = Hand.new(@deck)  
  end
  
 
  
end #dealer


# Below uses minitest
if __FILE__ == $PROGRAM_NAME
  require 'dust'
  require 'turn'
  
  class DealerTest < Test::Unit::TestCase
    def setup
      @dealer = Dealer.new
    end
    
    test "dealer is valid" do
      assert @dealer.is_a?(Dealer)
    end
    
    # initialization
    
    test "initializing creates a deck" do
      assert @dealer.deck.is_a?(Deck)
    end
    
    test "initializing creates a hand, belonging to the deck" do
      assert @dealer.hand.is_a?(Hand)
      assert_equal @dealer.deck, @dealer.hand.deck
    end
  end
  
  class HandTest < Test::Unit::TestCase
    def setup
      @deck = Deck.new
      @hand = Hand.new @deck 
    end
    
    test "is valid" do
      assert @hand.is_a?(Hand)
    end
    
    test "starts with zero cards" do
      assert @hand.cards.is_a?(Array)
      assert @hand.cards.empty?, "cards should start empty"
    end
    
    # deck
    
    test "belongs to a deck" do
      assert_equal @deck, @hand.deck, "deck was not initialized"
    end
    
    # hit
    
    test "returns the next card in the deck" do
      card1 = @deck.cards[0]

      @hand.hit
      assert_equal card1, @hand.cards[0], "hit should get the next deck card, but got #{@hand.cards[0]}"
    end
  end
  
  class DeckTest < Test::Unit::TestCase
    
    def setup
      @deck = Deck.new
    end

    test "creates 52 cards" do
      assert @deck.cards.is_a?(Array)
      assert_equal 52,   @deck.cards.size
    end
    
    test "contains 4 of each rank" do
      (2...14).each do |rank|
        rank_count = @deck.cards.select{ |card| card == rank }.size
        assert_equal 4, rank_count, "deck should have 4 '#{rank}' rank, but had #{rank_count}"
      end
    end
    
    test "shuffles the deck automatically" do
      deck1 = Deck.new
      deck2 = Deck.new
      
      assert_not_equal deck1.cards, deck2.cards, "the decks should not be in the same order"
    end
  
    # #deal
    
    test "#deal returns the next card in the deck" do
      card1 = @deck.cards[0]
      card2 = @deck.cards[1]
      
      assert_equal card1, @deck.deal, "first card did not match"
      assert_equal card2, @deck.deal, "second card did not match"
    end
    
    test "#deal returns nil when deck is empty" do
      52.times do
        assert @deck.deal.is_a?(Integer)
      end
      
      assert_equal nil, @deck.deal
    end
  end
end