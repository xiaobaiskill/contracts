//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract notReceiver {
    uint256 public nonce;
    uint256 public backNum;

    fallback() external {
        backNum++;
    }

    receive() external payable {
        require(msg.value == 0, "failed");
    }

    function notCall() external {
        nonce++;
    }

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
