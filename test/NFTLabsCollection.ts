import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { NFTLabsCollection__factory } from "../typechain-types";

describe("NFTLabsCollection", async () => {
  let NFTLabsCollectionFactory: any;
  let NFTLabsCollectionContract: any;

  let owner: any;
  let user: any;
  let andy: any;
  let bob: any;

  before(async () => {
    [owner, user, andy, bob] = await ethers.getSigners();

    NFTLabsCollectionFactory = (await ethers.getContractFactory(
      "NFTLabsCollection",
      owner
    )) as NFTLabsCollection__factory;
  });

  beforeEach(async () => {
    NFTLabsCollectionContract = await NFTLabsCollectionFactory.deploy(
      "NFTLabsCollection",
      "NFTLC"
    );
  });

  it("Name must be set as NFTLabsCollection", async () => {
    expect(await NFTLabsCollectionContract.name()).to.be.equals(
      "NFTLabsCollection"
    );
  });
  it("Symbol must be set as NFTLC", async () => {
    expect(await NFTLabsCollectionContract.symbol()).to.be.equals("NFTLC");
  });

  it("Owner can mint", async () => {
    await expect(
      NFTLabsCollectionContract.connect(owner).mint(owner.address, 1)
    )
      .to.emit(NFTLabsCollectionContract, "Transfer")
      .withArgs(ethers.constants.AddressZero, owner.address, 1);

    console.log(await NFTLabsCollectionContract.balanceOf(owner.address));
  });

  it("Owner can burn", async () => {
    await NFTLabsCollectionContract.connect(owner).mint(owner.address, 1);
    await NFTLabsCollectionContract.connect(owner).mint(owner.address, 2);

    console.log(await NFTLabsCollectionContract.balanceOf(owner.address));

    await expect(NFTLabsCollectionContract.connect(owner).burn(2)).to.emit(
      NFTLabsCollectionContract,
      "Transfer"
    ).withArgs(owner.address, ethers.constants.AddressZero, 2)

    console.log(await NFTLabsCollectionContract.balanceOf(owner.address));
  });

  it("Should be able to set and get baseURI", async () => {
    await expect(
      NFTLabsCollectionContract.connect(owner).setBaseURI("https://labs.com/")
    )
      .to.emit(NFTLabsCollectionContract, "BaseURIChanged")
      .withArgs("https://labs.com/");

    expect(await NFTLabsCollectionContract.baseURI()).to.be.equals(
      "https://labs.com/"
    );
  })

  it("Should mint and compute baseURI + tokenId", async () => {
     await NFTLabsCollectionContract.connect(owner).mint(owner.address, 1);
     await NFTLabsCollectionContract.connect(owner).mint(owner.address, 2);

     await NFTLabsCollectionContract.connect(owner).setBaseURI(
       "https://labs.com/"
     );

     expect(await NFTLabsCollectionContract.tokenURI(1)).to.be.equals(
       "https://labs.com/1.json"
     );

     expect(await NFTLabsCollectionContract.tokenURI(2)).to.be.equals(
       "https://labs.com/2.json"
     );
  })
});