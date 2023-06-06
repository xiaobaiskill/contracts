//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract destruction {
    // fallback() external {}

    receive() external payable {}

    uint256 public num;

    function setNum(uint256 _num) external {
        num = _num;
    }

    function kill(address receiver) external {
        selfdestruct(payable(receiver));
    }
}
