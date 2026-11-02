const hre = require("hardhat");

async function main() {
  const capsule = await hre.ethers.deployContract("ProofVault");
  await capsule.waitForDeployment();
  console.log("ProofVault deployed to:", await capsule.getAddress());
}

main().catch((e) => { console.error(e); process.exitCode = 1; });
