// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import "src/notReceiver.sol";
import "src/selfdestruct.sol";

contract TestScript is Script {
    uint256 privateKey;
    notReceiver nr;
    destruction dd;

    function setUp() public {
        privateKey = vm.envUint("PRIVATE_KEY_TEST");
        vm.startBroadcast(privateKey);
        nr = new notReceiver();
        dd = new destruction();
        vm.stopBroadcast();
    }

    function run() public {
        vm.startBroadcast(privateKey);

        (bool ok, ) = address(dd).call{value: 0.1 ether}("");
        require(ok, "transfer failed");
        // dd.kill(address(nr));
        vm.stopBroadcast();
    }
}
