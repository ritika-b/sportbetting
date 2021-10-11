// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;


contract Betting {

  Event[] public events;
  Bet[] public bets;

  uint8[] public staticPayoutOdds = [1, 1];

  // Think of this as a binary option: there are two outcomes (Suns win or Bucks win)
  struct Event {
    string option1;
    string option2;
    uint64 startTime;
    uint8[] payoutOdds;
    uint8 result;
  }

  // Create a struct which has the bet's characteristics and stats 
  struct Bet {
    address payable bettor;
    uint eventId;
    uint option;
    uint8[] payoutOdds;
    uint amount;
    uint8 claimed;
  }

  event NewEvent(uint id, string option1, string option2, uint64 startTime, uint8[] payoutOdds, uint8 result);
  event NewBet(uint id, address bettor, uint eventId, uint option, uint8[] payoutOdds, uint amount, uint8 claimed);
  event NewEventResult(uint id, uint8 result);

  function balanceOf() external view returns(uint) {
    return address(this).balance;
  }

  // need function to add new event
  function addEvent(string memory _option1, string memory _option2, uint64 _startTime) external onlyOwner {
    uint eventId = events.length;

    Event memory newEvent = Event(_option1, _option2, _startTime, staticPayoutOdds, 0);
    events.push(newEvent);

    emit NewEvent(eventId, _option1, _option2, _startTime, staticPayoutOdds, 0);
  }

  // need to refer to FCC stuff

  // getter method for getter events
  function getEvents() public view returns(Event[] memory) {
    return events;
  }

  // getter method for getting bets

  function setEventResult(uint _eventId, uint8 _result) external onlyOwner {
    events[_eventId].result = _result;

    emit NewEventResult(_eventId, _result);
  }

  // method to place bet
  function placeBet(uint _eventId, uint _option) external payable {
    require(events[_eventId].startTime > block.timestamp, "Bets cannot be placed after event has started");

    Event memory betEvent = events[_eventId];
    uint betId = bets.length;

    Bet memory bet = Bet(msg.sender, _eventId, _option, betEvent.payoutOdds, msg.value, 0);
    bets.push(bet);

    emit NewBet(betId, msg.sender, _eventId, _option, betEvent.payoutOdds, msg.value, 0);
  }

  // getter method for multiple bets
  function getBet(uint _betId) public view returns(Bet memory) {
    return bets[_betId];
  }


  // how do I take care of unclaimed bets/bets that have no payout yet?

  // Claim payout function
  
}