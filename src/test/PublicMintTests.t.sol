// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Test.t.sol";

contract MetaFashionTests is Test  {

    function setUp() public {
        _contract.unpause();
    }

    function testPublicMint() public {
        _contract.publicMint(1);
    }

}