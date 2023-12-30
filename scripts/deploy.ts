import { ethers } from "hardhat";

async function main() {
  const amount = ethers.parseEther("100");

  const payment = await ethers.deployContract("Payments", {
    value: amount,
  });

  await payment.waitForDeployment();

  console.log(
    `Payment with ${ethers.formatEther(amount)}ETH deployed to ${payment.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
