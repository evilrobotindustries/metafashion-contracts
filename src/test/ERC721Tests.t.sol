// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "./interfaces/CheatCodes.t.sol";
import "../Contract.sol";

contract ERC721Tests is DSTest {
    MetaFashion _contract;
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    function setUp() public {
        _contract = new MetaFashion();
    }

    function testName() public {
        assertEq("MetaFashion", _contract.name());
    }

    function testSymbol() public {
        assertEq("MFHQ", _contract.symbol());
    }
}