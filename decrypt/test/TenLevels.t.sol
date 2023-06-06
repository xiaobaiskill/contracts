// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/TenLevels.sol";

contract CounterTest is Test {
    TenLevels tl;

    uint256 userPrivateKey = 0xF0F;
    address user = vm.addr(userPrivateKey);

    function setUp() public {
        tl = new TenLevels();
        vm.deal(address(tl), 5.1 ether);
    }

    function testClaim() public {
        // vm.store();

        vm.startPrank(user);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 900000000;
        tl.claimRewards(tokenIds);
        vm.stopPrank();
    }
}
