//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import "src/notReceiver.sol";
import "src/selfdestruct.sol";

contract MintsTest is Test {
    notReceiver nr;
    destruction dd;

    uint256 userPrivateKey = 0xF0F;
    address user = vm.addr(userPrivateKey);

    uint256 anotherPrivateKey = 0xC0C;
    address another = vm.addr(anotherPrivateKey);

    function setUp() public {
        nr = new notReceiver();
        dd = new destruction();

        vm.deal(user, 100 ether);

        vm.warp(1683018039);
    }

    function testKill() public {
        bool ok;
        vm.startPrank(user);
        (ok, ) = address(nr).call{value: 1 ether}("");
        assertEq(ok, false);

        (ok, ) = address(dd).call{value: 1 ether}("");
        assertEq(ok, true);

        (ok, ) = another.call{value: 1 ether}("");
        assertEq(ok, true);
        vm.stopPrank();

        assertEq(address(dd).balance, 1 ether);

        dd.kill(address(nr));

        assertEq(address(dd).balance, 0 ether);

        assertEq(address(nr).balance, 1 ether);
    }
}
