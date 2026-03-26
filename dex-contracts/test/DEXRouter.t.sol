// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./helpers/TestSetup.sol";

contract DEXRouterTest is TestSetup {
    
    function setUp() public override {
        super.setUp();
        // Give router approval max for both tokens from owner/user are already handled
    }

    function test_AddLiquidity() public {
        vm.startPrank(user);
        
        (uint amountA, uint amountB, uint liquidity) = router.addLiquidity(
            address(tokenA),
            address(tokenB),
            100 ether,
            100 ether,
            0,
            0,
            user,
            block.timestamp + 100
        );
        
        assertEq(amountA, 100 ether);
        assertEq(amountB, 100 ether);
        
        address pairAddress = factory.getPair(address(tokenA), address(tokenB));
        DEXPair pair = DEXPair(pairAddress);
        
        // MINIMUM_LIQUIDITY (1000) is locked permanently on first mint
        assertEq(liquidity, 100 ether - 1000);
        assertEq(pair.balanceOf(user), 100 ether - 1000);
        assertEq(pair.totalSupply(), 100 ether);
        
        vm.stopPrank();
    }

    function testFuzz_SwapExactTokensForTokens(uint256 amountIn) public {
        // Bound the fuzzing to reasonable amount that guarantees > 0 output
        vm.assume(amountIn > 1000 && amountIn < 10000 ether);

        // 1. Setup liquidity
        vm.startPrank(owner);
        tokenA.mint(owner, 100000 ether);
        tokenB.mint(owner, 100000 ether);
        tokenA.approve(address(router), type(uint256).max);
        tokenB.approve(address(router), type(uint256).max);
        
        router.addLiquidity(
            address(tokenA),
            address(tokenB),
            100000 ether,
            100000 ether,
            0,
            0,
            owner,
            block.timestamp + 100
        );
        vm.stopPrank();

        // 2. Perform Swap
        vm.startPrank(user);
        uint256 balanceBBefore = tokenB.balanceOf(user);
        
        address[] memory path = new address[](2);
        path[0] = address(tokenA);
        path[1] = address(tokenB);
        
        uint[] memory amounts = router.getAmountsOut(amountIn, path);
        uint expectedOut = amounts[1];
        
        router.swapExactTokensForTokens(
            amountIn,
            0,
            path,
            user,
            block.timestamp + 100
        );
        
        uint256 balanceBAfter = tokenB.balanceOf(user);
        assertEq(balanceBAfter - balanceBBefore, expectedOut);
        
        vm.stopPrank();
    }
    
    function testRevert_ExpiredDeadline() public {
        vm.startPrank(user);
        
        vm.expectRevert("DEXRouter: EXPIRED");
        router.addLiquidity(
            address(tokenA),
            address(tokenB),
            100 ether,
            100 ether,
            0,
            0,
            user,
            block.timestamp - 1 // Past deadline
        );
        
        vm.stopPrank();
    }
}
