// scripts/upgrade_ERC20UUPS.js
const { ethers, upgrades } = require("hardhat");

const PROXY = "0xc05bD1968A830Cd592095aCdf31c3565318690C5";

async function main() {
    const Tokenv2 = await ethers.getContractFactory("Tokenv2");
    console.log("Upgrading Tokenv2...");
    await upgrades.upgradeProxy(PROXY, Tokenv2);
    console.log("Tokenv2 upgraded");
}

main();
