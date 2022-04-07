// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "../Contract.sol";

contract PausableTests is DSTest {
    MetaFashion _contract;

    function setUp() public {
        _contract = new MetaFashion();
    }

    function testPausedInitially() public {
        assertTrue(_contract.paused());
    }

    function testUnpauses() public {
        assertTrue(_contract.paused());
        _contract.unpause();
        assertTrue(!_contract.paused());
    }

    function testFailWhenAlreadyPaused() public {
        assertTrue(_contract.paused());
        _contract.pause();
    }
}