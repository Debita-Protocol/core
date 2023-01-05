import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";



const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
    const { deployments, getNamedAccounts } = hre;
    const { deployer } = await getNamedAccounts();
    const interep = "0x0000000000000000000000000000000000000000"; //"0xb1dA5d9AC4B125F521DeF573532e9DBb6395B925";
    const args = [deployer, interep];

    // if (!(await deployments.getOrNull("Collateral"))) {
    //   await deployments.deploy("Collateral", {
    //     contract: "Cash",
    //     from: deployer,
    //     args: ["USDC", "USDC", 6],
    //     log: true,
    //   });
    // }
   await deployments.deploy("Collateral", {
        contract: "Cash",
        from: deployer,
        args: ["USDC", "USDC", 18],
        log: true,
      });
    await deployments.deploy("Controller", {
      contract: "Controller",
      from: deployer,
      args,
      log: true,
    });
  };
  
  func.tags = ["Controller"];
  
  export default func;