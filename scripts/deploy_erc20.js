const { ethers, upgrades } = require("hardhat");

async function main() {
    const Tokenv1 = await ethers.getContractFactory("Tokenv1");
    console.log("Deploying Tokenv1...");
    const erc20 = await upgrades.deployProxy(Tokenv1, {kind:'uups'});
    await erc20.deployed();
    console.log("Tokenv1 deployed to:", erc20.address);
}

main();
