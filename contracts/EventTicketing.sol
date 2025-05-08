// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventTicketing {
    struct Event {
        string name;
        uint totalTickets;
        uint ticketPrice;
        uint date;
        bool isCancelled;
        address payable organizer;
        uint ticketsSold;
    }

    mapping(uint => Event) public events;
    uint public nextEventId;
    mapping(uint => mapping(address => uint)) public ticketBalances;

    address public _owner;

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only current owner can transfer ownership");
        _;
    }

    function owner() public view returns (address) {
        return _owner;
    }
function transferTicket(uint eventId, address to, uint quantity) external {
    require(to != address(0), "Invalid recipient address");
    require(quantity > 0, "Quantity must be greater than 0");
    uint senderBalance = ticketBalances[eventId][msg.sender];
    require(senderBalance >= quantity, "Not enough tickets");

    ticketBalances[eventId][msg.sender] -= quantity;
    ticketBalances[eventId][to] += quantity;
}

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        _owner = newOwner;
    }

    function createEvent(
        string memory _name,
        uint _totalTickets,
        uint _ticketPrice,
        uint _date
    ) external {
        require(_date > block.timestamp, "Event must be in the future");
        require(_totalTickets > 0, "Must have at least one ticket");

        events[nextEventId] = Event({
            name: _name,
            totalTickets: _totalTickets,
            ticketPrice: _ticketPrice,
            date: _date,
            isCancelled: false,
            organizer: payable(msg.sender),
            ticketsSold: 0
        });

        nextEventId++;
    }

    function purchaseTickets(uint eventId, uint quantity) external payable {
        Event storage ev = events[eventId];
        require(block.timestamp < ev.date, "Event already occurred");
        require(!ev.isCancelled, "Event is cancelled");
        require(quantity > 0 && quantity <= ev.totalTickets - ev.ticketsSold, "Not enough tickets");
        require(msg.value == quantity * ev.ticketPrice, "Incorrect value sent");

        ticketBalances[eventId][msg.sender] += quantity;
        ev.ticketsSold += quantity;
    }

    function cancelEvent(uint eventId) external {
        Event storage ev = events[eventId];
        require(msg.sender == ev.organizer, "Only organizer can cancel");
        require(!ev.isCancelled, "Already cancelled");

        ev.isCancelled = true;
    }

    // ✅ UPDATED: ABI-compatible version of getAllEvents
    function getAllEvents() public view returns (
    string[] memory names,
    uint[] memory totalTicketsArray,
    uint[] memory ticketPrices,
    uint[] memory dates,
    bool[] memory isCancelledArray,
    address[] memory organizers,
    uint[] memory ticketsSoldArray
) {
    names = new string[](nextEventId);
    totalTicketsArray = new uint[](nextEventId);
    ticketPrices = new uint[](nextEventId);
    dates = new uint[](nextEventId);
    isCancelledArray = new bool[](nextEventId);
    organizers = new address[](nextEventId);
    ticketsSoldArray = new uint[](nextEventId);

    for (uint i = 0; i < nextEventId; i++) {
        Event storage ev = events[i];
        names[i] = ev.name;
        totalTicketsArray[i] = ev.totalTickets;
        ticketPrices[i] = ev.ticketPrice;
        dates[i] = ev.date;
        isCancelledArray[i] = ev.isCancelled;
        organizers[i] = ev.organizer;
        ticketsSoldArray[i] = ev.ticketsSold;
    }
}


    function withdrawFunds(uint eventId) external {
        Event storage ev = events[eventId];
        require(msg.sender == ev.organizer, "Only organizer can withdraw");
        require(!ev.isCancelled, "Cannot withdraw from cancelled event");

        uint balance = ev.ticketPrice * ev.ticketsSold;
        ev.ticketsSold = 0;
        ev.organizer.transfer(balance);
    }

    function getEventDetails(uint eventId) external view returns (
        string memory name,
        uint totalTickets,
        uint ticketPrice,
        uint date,
        bool isCancelled,
        address organizer,
        uint ticketsSold
    ) {
        require(eventId < nextEventId, "Event does not exist");
        Event storage ev = events[eventId];
        return (
            ev.name,
            ev.totalTickets,
            ev.ticketPrice,
            ev.date,
            ev.isCancelled,
            ev.organizer,
            ev.ticketsSold
        );
    }

    function getTicketBalance(uint eventId, address user) external view returns (uint) {
        return ticketBalances[eventId][user];
    }
}
