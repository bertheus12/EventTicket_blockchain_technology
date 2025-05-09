
#  EventTicketing Smart Contract

This is a Solidity-based smart contract that allows users to create events, purchase and transfer tickets, cancel events, and withdraw funds. It's designed for building a decentralized event ticketing platform on Ethereum.

##  Features

- Event creation with customizable details (name, tickets, price, date)
- Ticket purchase with Ether payments
-  Ticket transfers between users
-  Event cancellation by the organizer
-  Fund withdrawal by organizers
-  View all events and individual event details

## github link  
https://github.com/bertheus12/EventTicket_blockchain_technology

## youtube link 
https://www.youtube.com/watch?v=PqEcxIazJps
##  Tech Stack

- **Solidity** ^0.8.0
- **Ethereum** Blockchain
- **Remix**, **Hardhat**, or **Foundry** for development/testing

##  Contract Overview

### Structs

- `Event`: Stores metadata about each event including ticket count, price, organizer, etc.

### State Variables

- `events`: Stores all created events by ID.
- `ticketBalances`: Tracks tickets owned by users per event.
- `nextEventId`: Auto-incrementing ID for new events.
- `_owner`: The contract owner.

### Key Functions

| Function | Description |
|----------|-------------|
| `createEvent()` | Create a new event |
| `purchaseTickets()` | Buy tickets by paying ETH |
| `transferTicket()` | Transfer tickets to another address |
| `cancelEvent()` | Cancel an event (organizer only) |
| `withdrawFunds()` | Organizer can withdraw revenue from ticket sales |
| `getAllEvents()` | Get arrays of all event details |
| `getEventDetails()` | View full details of a single event |
| `getTicketBalance()` | Check user's ticket balance for a specific event |

### Deploying

Use Remix or Hardhat to deploy:

Try running some of the following tasks:

```shell
checking version 
npm -v
node -v
npx hardhat help
npx hardhat compile
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js --network localhost
npm install
npm start

```
# EventTicket_blockchain_technology
