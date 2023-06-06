const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const { ethers } = require("hardhat");

async function main() {
  const whitelistAddresses = [
    "0x0000000000000000000000015B38Da6a701c568545dCfcB03FcB875f56beddC4",
    "0x000000000000000000000002c12ae5Ba30Da6eB11978939379D383beb5Df9b33",
    "0x0000000000000000000000030a290c8cE7C35c40F4F94070a9Ed592fC85c62B9",
    "0x00000000000000000000000443Be076d3Cd709a38D2f83Cd032297a194196517",
    "0x000000000000000000000005C7FaB03eecA24CcaB940932559C5565a4cE9cFFb",
    "0x000000000000000000000006E4336D25e9Ca0703b574a6fd1b342A4d0327bcfa",
    "0x000000000000000000000007eDcB8a28161f966C5863b8291E80dDFD1eB78491",
    "0x00000000000000000000000877cbd0fa30F83a249da282e9fE90A86d7936FdE7",
    "0x000000000000000000000009c39F9406284CcAeB426D0039a3F6ADe14573BaFe",
    "0x00000000000000000000000a16Beb6b55F145E4269279B82c040B7435f1088Ee",
    "0x00000000000000000000000b900b2909127Dff529f8b4DB3d83b957E6aE964c2",
    "0x00000000000000000000000ceA2A799793cE3D2eC6BcD066563f385F25401e95",
    "0x00000000000000000000000dAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
    "0x00000000000000000000000ef39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
  ];

  // 1.叶子节点数据制作
  const leafNodes = [];
  for (const test in whitelistAddresses) {
    const leafNode = ethers.utils.keccak256(whitelistAddresses[test]);
    // console.log(leafNode);
    leafNodes.push(leafNode);
  }

  // 2.生成树根
  const tree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
  console.log("root: ", tree.getHexRoot());

  // 3.生成叶子的proof(需要检验的地址)
  console.log(`address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; token: 1: `, tree.getHexProof(leafNodes[0]));

//   console.log(tree)
}

main();
