
import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";
import { CharityCampaigns } from "../typechain-types";
import { CharityCampaigns__factory } from "../typechain-types";

task("deploy:CharityCampaigns").setAction(async function (
  taskArguments: TaskArguments,
  { ethers }
) {
  const CharityCampaignsFactory: CharityCampaigns__factory = <
    CharityCampaigns__factory
  >await ethers.getContractFactory("CharityCampaigns");

  const CharityCampaigns: CharityCampaigns = <CharityCampaigns>(
    await CharityCampaignsFactory.deploy()
  );

  await CharityCampaigns.deployed();

  console.log("Contract deployes to: ", CharityCampaigns.address);
});