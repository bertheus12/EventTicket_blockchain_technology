const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const EventTicketing = await ethers.getContractFactory("EventTicketing");

  const contract = await EventTicketing.deploy(); // Automatically waits in ethers v6

  if (!contract.target) {
    console.error("Contract deployment failed: contract.target is undefined.");
    process.exit(1);
  }

  console.log("EventTicketing contract deployed successfully to:", contract.target);
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exitCode = 1;
});
