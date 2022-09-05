const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
let PROXY;
let Tokendeployed;
let Tokenv1;
let Tokenv2;
let owner;
let addr1;
let addr2;


describe("Deploying Tokenv1...", function () {
  it("Should deploy succesfully", async function () {
    Tokenv1 = await ethers.getContractFactory("Tokenv1");
    console.log("Deploying Tokenv1...");
    Tokendeployed = await upgrades.deployProxy(Tokenv1, {kind:'uups'});
    await Tokendeployed.deployed();
    [owner, addr1, addr2] = await ethers.getSigners();
    console.log("Tokenv1 deployed to:", Tokendeployed.address);
    PROXY=Tokendeployed.address;
  });
  it("Should mint initial supply...", async function () {
    console.log("Consulting Version...");
    const balanceOf = await Tokendeployed.balanceOf(owner.address);
    console.log("balanceOf: "+balanceOf);
  });
});

describe("Updating to Tokenv2...", function () {
  it("Should update to v2 succesfully", async function () {
    Tokenv2 = await ethers.getContractFactory("Tokenv2");
    console.log("Upgrading Tokenv2...");
    Tokendeployed = await upgrades.upgradeProxy(PROXY, Tokenv2);
    await Tokendeployed.deployed
    console.log("Tokenv2 upgraded");
  });
  it("Should return v2 on version function...", async function () {
    console.log("Consulting Version...");
    const version = await Tokendeployed.version();
    console.log("version: "+version);
  });
  it("Should grant blacklist role to address1...", async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    console.log("Granting Blacklisting role Address: "+owner.address);

    console.log("Owner Address: "+owner.address);
    await Tokendeployed.grant_BLACKLISTER_ROLE(owner.address);
  });
  it("Should blacklist address1...", async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    console.log("Blacklisting Address: "+addr1.address);

    console.log("Owner Address: "+owner.address);
    await Tokendeployed.blacklist_address(addr1.address);
  });
});
