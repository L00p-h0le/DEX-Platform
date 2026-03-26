// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/DEXFactory.sol";
import "../src/DEXRouter.sol";
import "../src/tokens/TokenA.sol";
import "../src/tokens/TokenB.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy Test Tokens
        TokenA tokenA = new TokenA();
        TokenB tokenB = new TokenB();
        console.log("TokenA deployed at:", address(tokenA));
        console.log("TokenB deployed at:", address(tokenB));

        // 2. Deploy Factory
        DEXFactory factory = new DEXFactory(deployer);
        console.log("DEXFactory deployed at:", address(factory));

        // 3. Deploy Router
        DEXRouter router = new DEXRouter(address(factory));
        console.log("DEXRouter deployed at:", address(router));

        // 4. Create initial pair for TokenA/TokenB
        address pair = factory.createPair(address(tokenA), address(tokenB));
        console.log("DEXPair (TKNA/TKNB) created at:", pair);

        vm.stopBroadcast();
        
        console.log("\n--- Deployment Complete ---");
        console.log("Next steps: Add liquidity using the Router to initialize the pool!");
    }
}
