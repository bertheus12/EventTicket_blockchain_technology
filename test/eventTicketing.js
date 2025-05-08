const { expect } = require("chai");
const { ethers } = require("hardhat");
const { parseEther } = require("ethers");
require("@nomicfoundation/hardhat-chai-matchers");

describe("EventTicketing", function () {
  let eventTicketing;
  let owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    const EventTicketing = await ethers.getContractFactory("EventTicketing");
    eventTicketing = await EventTicketing.deploy();
  });

  it("should create a new event", async function () {
    const futureTime = Math.floor(Date.now() / 1000) + 24 * 60 * 60;
    await eventTicketing.createEvent("Test Event", 100, parseEther("0.1"), futureTime);
    const event = await eventTicketing.getEventDetails(0);
    expect(event.name).to.equal("Test Event");
    expect(event.totalTickets).to.equal(BigInt(100));
  });

  it("should allow users to purchase tickets", async function () {
    const futureTime = Math.floor(Date.now() / 1000) + 24 * 60 * 60;
    await eventTicketing.createEvent("Concert", 10, parseEther("0.1"), futureTime);

    await eventTicketing.connect(addr1).purchaseTickets(0, 2, {
      value: parseEther("0.2"),
    });

    const tickets = await eventTicketing.getTicketBalance(0, addr1.address);
    expect(tickets).to.equal(2);
  });

  it("should allow organizer to cancel the event", async function () {
    const futureTime = Math.floor(Date.now() / 1000) + 24 * 60 * 60;
    await eventTicketing.createEvent("Workshop", 5, parseEther("0.1"), futureTime);
    await eventTicketing.cancelEvent(0);
    const event = await eventTicketing.getEventDetails(0);
    expect(event.isCancelled).to.equal(true);
  });

  it("should prevent purchasing after cancellation", async function () {
    const futureTime = Math.floor(Date.now() / 1000) + 24 * 60 * 60;
    await eventTicketing.createEvent("Seminar", 5, parseEther("0.1"), futureTime);
    await eventTicketing.cancelEvent(0);

    await expect(
      eventTicketing.connect(addr1).purchaseTickets(0, 1, {
        value: parseEther("0.1"),
      })
    ).to.be.revertedWith("Event is cancelled");
  });

  it("should allow withdrawing funds by organizer", async function () {
    const futureTime = Math.floor(Date.now() / 1000) + 24 * 60 * 60;
    await eventTicketing.createEvent("Webinar", 5, parseEther("1"), futureTime);
  
    await eventTicketing.connect(addr1).purchaseTickets(0, 1, {
      value: parseEther("1"),
    });
  
    const balanceBefore = BigInt(await ethers.provider.getBalance(owner.address));
    const tx = await eventTicketing.withdrawFunds(0);
    const receipt = await tx.wait();
  
    const gasUsed = receipt.gasUsed && receipt.effectiveGasPrice
      ? BigInt(receipt.gasUsed.toString()) * BigInt(receipt.effectiveGasPrice.toString())
      : BigInt(0);
  
    const balanceAfter = BigInt(await ethers.provider.getBalance(owner.address));
  
    expect(balanceAfter).to.be.greaterThan(balanceBefore - gasUsed);
  });
  
  
});
