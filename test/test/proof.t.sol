//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import "src/proof.sol";

contract ProofTest is Test {
    proof p;

    uint256 privateKey = 0xF0F;
    address publickey = vm.addr(privateKey);

    function setUp() public {
        p = new proof(
            0x961ca57cefcaef8d69d76953bad6bccdc8564d9169884a52b866c662561fed64
        );

        vm.warp(1683018039);
    }

    function testVerifyProof() public {
        bytes32[] memory _proofs = new bytes32[](4);
        _proofs[
            0
        ] = 0x9b3a52ecdc3b8ebd10df1a5bea317d5ff2485b7ef57d5c1b5ef8361e09928eb1;
        _proofs[
            1
        ] = 0x8ab7cce61a33275bb385f3abb093eeaf972bf127b658261e1db9d7a7055ac125;
        _proofs[
            2
        ] = 0x8461c5e4d68e92a253864bca4b30df77c88033767e576088168c22000504ce17;
        _proofs[
            3
        ] = 0x18a9adc13141f741a5f2c2aa52622b060f707345f2017c8d0430e67e76f40730;

        p.mintToken(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 1, _proofs);
    }
}
