// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Test.t.sol";

contract MetaFashionTests is Test  {

    function setUp() public {
        _contract.unpause();
    }

    function testVIPMint() public {
        _contract.setContractStatus(MetaFashion.ContractStatus.VIPOnly);
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = bytes32(bytes("2a80e1ef1d7842f27f2e6be0972bb708b9a135c38860dbe73c27c3486c34f4de"));
        _cheatCodes.prank(address(1));
        _contract.vipMint(1, proof);
    }
}