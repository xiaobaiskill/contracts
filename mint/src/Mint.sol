// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "src/Ownable.sol";
import "src/Context.sol";
import "src/interfaces/IERC20.sol";

contract Mint is Ownable {
    address public _token;

    uint256 public _currentAmount;

    uint256 public _totalCount;
    uint256 public immutable _rate;

    struct Person {
        // 1 + 5 + 5 + 4 = 15
        bool initial;
        uint40 mintTime;
        uint40 startTime;
        uint32 inviteCount; // 0xffffffff = 4294967295; the invite count exceed 4294967295?
        uint256 claim;
        uint256 unclaim;
    }
    struct Invite {
        // 20 + 5 = 25
        address addr;
        uint40 datetime;
    }

    mapping(address => Person) public _users;
    mapping(address => Invite[]) public _invites;
    mapping(address => address) public _exitsCheck;

    constructor(address token, uint256 rate) {
        _token = token; // Mint token address
        _rate = rate;
    }

    function startMint(address refer) public {
        require(
            msg.sender == tx.origin,
            "Only external accounts can call this function"
        );
        require(
            !isContract(msg.sender),
            "Only external accounts can call this function"
        );
        require(!_users[msg.sender].initial, "repeat start");
        Person memory newPerson;
        newPerson.initial = true;
        newPerson.mintTime = uint40(block.timestamp);
        newPerson.startTime = uint40(block.timestamp);
        newPerson.inviteCount = 0;
        newPerson.claim = 0;
        newPerson.unclaim = 0;
        _users[msg.sender] = newPerson;
        _totalCount += 1;

        if (refer == address(0) || refer == msg.sender) {
            return;
        }
        if (_exitsCheck[msg.sender] == address(0)) {
            if (_users[refer].initial) {
                uint256 unclaim = _users[refer].unclaim;
                unclaim +=
                    (block.timestamp - _users[refer].startTime) *
                    (_rate * _users[refer].inviteCount + _rate);
                _users[refer].unclaim = unclaim;
                _users[refer].startTime = uint40(block.timestamp);
            }

            _users[refer].inviteCount += 1;
            Invite memory invite = Invite(msg.sender, uint40(block.timestamp));
            _invites[refer].push(invite);

            _exitsCheck[msg.sender] = refer;
        }
    }

    function withdraw() public {
        require(
            msg.sender == tx.origin,
            "Only external accounts can call this function"
        );
        require(
            !isContract(msg.sender),
            "Only external accounts can call this function"
        );
        require(_users[msg.sender].initial, "initial error");
        require(
            (block.timestamp - _users[msg.sender].startTime) > 0,
            "too fast"
        );

        uint256 claim = (block.timestamp - _users[msg.sender].startTime) *
            (_rate * _users[msg.sender].inviteCount + _rate);
        uint256 unclaim = _users[msg.sender].unclaim;

        IERC20(_token).transfer(msg.sender, unclaim + claim);

        _users[msg.sender].unclaim = 0;
        _users[msg.sender].claim += (unclaim + claim);
        _users[msg.sender].startTime = uint40(block.timestamp);

        _currentAmount += (unclaim + claim);
    }

    function getRewards(address addr) public view returns (uint256) {
        if (!_users[addr].initial) {
            return 0;
        }
        uint256 claim = (block.timestamp - _users[addr].startTime) *
            (_rate * _users[addr].inviteCount + _rate);
        uint256 unclaim = _users[addr].unclaim;
        return (claim + unclaim);
    }

    function withdrawToken(
        address token,
        address recipient,
        uint amount
    ) external onlyOwner {
        IERC20(token).transfer(recipient, amount);
    }

    function withdrawBNB() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function isContract(address addr) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(addr)
        }
        return (size > 0);
    }
}
