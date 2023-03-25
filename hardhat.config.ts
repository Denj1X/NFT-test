import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";
import "./tasks/NFTLabsCollection.ts";
require("dotenv").config();

const chainIdMumbai = 80001;

const getMumbaiConfig = () => {
  const url = process.env.SERVER_PROVIDER as string;

  return {
    accounts: process.env.PRIVATE_KEY
      ? [`${process.env.PRIVATE_KEY}`]
      : ["0x0000000000000000000000000000000000000000"],
    chainId: chainIdMumbai,
    url,
  };
};

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  defaultNetwork: "hardhat",
  networks: {
    mumbai: getMumbaiConfig(),
  },
  etherscan: {
    apiKey: process.env.ALCHEMY_API_KEY as string,
  },
};

export default config;
