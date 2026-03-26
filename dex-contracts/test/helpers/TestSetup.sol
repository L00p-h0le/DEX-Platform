// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/DEXFactory.sol";
import "../../src/DEXPair.sol";
import "../../src/DEXRouter.sol";
import "../../src/tokens/TokenA.sol";
import "../../src/tokens/TokenB.sol";

contract TestSetup is Test {
    DEXFactory factory;
    DEXRouter router;
    TokenA tokenA;
    TokenB tokenB;

    address owner = address(1);
    address user = address(2);
    address user2 = address(3);

    function setUp() public virtual {
        vm.startPrank(owner);
        factory = new DEXFactory(owner);
        router = new DEXRouter(address(factory));
        tokenA = new TokenA();
        tokenB = new TokenB();
        
        // Fund users
        tokenA.mint(user, 1000000 ether);
        tokenB.mint(user, 1000000 ether);
        tokenA.mint(user2, 1000000 ether);
        tokenB.mint(user2, 1000000 ether);
        vm.stopPrank();
        
        vm.startPrank(user);
        tokenA.approve(address(router), type(uint256).max);
        tokenB.approve(address(router), type(uint256).max);
        vm.stopPrank();
        
        vm.startPrank(user2);
        tokenA.approve(address(router), type(uint256).max);
        tokenB.approve(address(router), type(uint256).max);
        vm.stopPrank();
    }
}
