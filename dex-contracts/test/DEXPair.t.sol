// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./helpers/TestSetup.sol";

contract DEXPairTest is TestSetup {
    DEXPair pair;
    
    function setUp() public override {
        super.setUp();
        vm.startPrank(owner);
        address pairAddress = factory.createPair(address(tokenA), address(tokenB));
        pair = DEXPair(pairAddress);
        vm.stopPrank();
    }
    
    function test_Mint() public {
        vm.startPrank(user);
        tokenA.transfer(address(pair), 1 ether);
        tokenB.transfer(address(pair), 1 ether);
        
        pair.mint(user);
        
        assertEq(pair.totalSupply(), 1 ether);
        assertEq(pair.balanceOf(user), 1 ether - 1000); // 1000 is MINIMUM_LIQUIDITY
        
        (uint112 reserve0, uint112 reserve1,) = pair.getReserves();
        assertEq(reserve0, 1 ether);
        assertEq(reserve1, 1 ether);
        vm.stopPrank();
    }
    
    function test_Burn() public {
        vm.startPrank(user);
        tokenA.transfer(address(pair), 1 ether);
        tokenB.transfer(address(pair), 1 ether);
        pair.mint(user);
        
        pair.transfer(address(pair), pair.balanceOf(user));
        pair.burn(user);
        
        assertEq(tokenA.balanceOf(user), 1000000 ether - 1000); // minus minimum liquidity
        assertEq(tokenB.balanceOf(user), 1000000 ether - 1000);
        vm.stopPrank();
    }
    
    function test_Swap() public {
        // 1. Give pair initial liquidity
        vm.startPrank(owner);
        tokenA.transfer(address(pair), 100 ether);
        tokenB.transfer(address(pair), 100 ether);
        pair.mint(owner);
        vm.stopPrank();
        
        // 2. User swaps 10 A for some B
        vm.startPrank(user);
        tokenA.transfer(address(pair), 10 ether);
        
        uint amountInWithFee = 10 ether * 997;
        uint numerator = amountInWithFee * 100 ether;
        uint denominator = (100 ether * 1000) + amountInWithFee;
        uint expectedBOut = numerator / denominator;
        
        address token0 = pair.token0();
        uint amount0Out = address(tokenA) == token0 ? 0 : expectedBOut;
        uint amount1Out = address(tokenA) == token0 ? expectedBOut : 0;
        
        pair.swap(amount0Out, amount1Out, user);
        
        uint balanceB = tokenB.balanceOf(user);
        assertEq(balanceB, 1000000 ether + expectedBOut);
        vm.stopPrank();
    }
}
