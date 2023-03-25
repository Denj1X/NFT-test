import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";
import { NFTLabsCollection } from "../typechain-types";
import { NFTLabsCollection__factory } from "../typechain-types";

//deployed: 

task("deploy:NFTLabsCollection").setAction(async function (
  taskArguments: TaskArguments,
  { ethers }
) {
  const NFTCollectionFactory: NFTLabsCollection__factory = <NFTLabsCollection__factory>(
    await ethers.getContractFactory("NFTLabsCollection")
  );
  const NFTLabsCollection: NFTLabsCollection = <NFTLabsCollection>(
    await NFTCollectionFactory.deploy("NFTLabsCollection", "NFTLC")
  );
  await NFTLabsCollection.deployed();
  console.log("NFTLabsCollection deployed to: ", NFTLabsCollection.address);
});