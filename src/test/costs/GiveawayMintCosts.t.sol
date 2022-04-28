// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "../Test.t.sol";

contract GiveawayMintCosts is Test  {

    function setUp() public {
        _contract.unpause();
        _contract.setPhase(MetaFashion.MintPhase.VIP);
    }

    function testMint() public {       
        _contract.giveawayMint();
    }
}