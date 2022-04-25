// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "ds-test/test.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleTests is DSTest {

   function testMerkle() public {
      bytes32[] memory proof = new bytes32[](2);
      proof[0] = 0x5b70e80538acdabd6137353b0f9d8d149f4dba91e8be2e7946e409bfdbe685b9;
      proof[1] = 0xd52688a8f926c816ca1e079067caba944f158e764817b83fc43594370ca9cf62;

      bytes32 root = 0x7c9a6bf3de43ef03c24f3fffbe0a5a52057670d5f03702b6d753b13f4a584451;

      address a = address(1);
      bytes32 leaf = keccak256(abi.encodePacked(a));

      assertTrue(MerkleProof.verify(proof, root, leaf));
   }
}