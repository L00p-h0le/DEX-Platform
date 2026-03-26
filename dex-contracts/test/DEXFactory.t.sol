// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./helpers/TestSetup.sol";

contract DEXFactoryTest is TestSetup {
    
    function test_CreatePair() public {
        address pair = factory.createPair(address(tokenA), address(tokenB));
        
        assertTrue(pair != address(0));
        assertEq(factory.getPair(address(tokenA), address(tokenB)), pair);
        assertEq(factory.getPair(address(tokenB), address(tokenA)), pair);
        assertEq(factory.allPairsLength(), 1);
        
        DEXPair dexPair = DEXPair(pair);
        assertTrue(dexPair.token0() == address(tokenA) || dexPair.token0() == address(tokenB));
        assertTrue(dexPair.token1() == address(tokenA) || dexPair.token1() == address(tokenB));
    }
    
    function testRevert_CreateIdenticalTokens() public {
        vm.expectRevert("DEX: IDENTICAL_ADDRESSES");
        factory.createPair(address(tokenA), address(tokenA));
    }
    
    function testRevert_CreateZeroAddress() public {
        vm.expectRevert("DEX: ZERO_ADDRESS");
        factory.createPair(address(tokenA), address(0));
    }
    
    function testRevert_CreateExistingPair() public {
        factory.createPair(address(tokenA), address(tokenB));
        
        vm.expectRevert("DEX: PAIR_EXISTS");
        factory.createPair(address(tokenA), address(tokenB));
    }
    
    function test_SetFeeTo() public {
        vm.startPrank(owner);
        factory.setFeeTo(user);
        assertEq(factory.feeTo(), user);
        vm.stopPrank();
    }
    
    function testRevert_SetFeeToUnauthorized() public {
        vm.startPrank(user);
        vm.expectRevert("DEX: FORBIDDEN");
        factory.setFeeTo(user2);
        vm.stopPrank();
    }
}
