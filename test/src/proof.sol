//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract proof {
    mapping(uint256 => address) public tokenIds;
    bytes32 public proofRoot;

    constructor(bytes32 _proofRoot) {
        proofRoot = _proofRoot;
    }

    function mintToken(
        address _user,
        uint96 _tokenId,
        bytes32[] calldata proofs
    ) external {
        bytes32 leaf_;
        assembly {
            let tokenIdUser_ := or(shl(160, _tokenId), _user)
            mstore(0x0, tokenIdUser_)
            leaf_ := keccak256(0x0, 0x20)
        }
        require(verifyProof(leaf_, proofs) == proofRoot, "invalid proof");
        tokenIds[_tokenId] = _user;
    }

    function verifyProof(bytes32 _leaf, bytes32[] memory _proofs)
        internal
        pure
        returns (bytes32 computedHash)
    {
        computedHash = _leaf;
        for (uint256 i = 0; i < _proofs.length; ) {
            computedHash = _hashPair(computedHash, _proofs[i]);
            unchecked {
                i++;
            }
        }
    }

    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
    }

    function _efficientHash(bytes32 a, bytes32 b)
        private
        pure
        returns (bytes32 value)
    {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}
