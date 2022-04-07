// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "./interfaces/CheatCodes.t.sol";
import "../MetaFashion.sol";

contract PausableTests is DSTest {
    MetaFashion _contract;
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    bytes32 constant VIP_MERKLE_ROOT = bytes32(bytes("as9d87sad98as7d98sa7d"));

    function setUp() public {
        _contract = new MetaFashion(VIP_MERKLE_ROOT);
    }

    function testPausedInitially() public {
        assertTrue(_contract.paused());
    }

    function testPauses() public {
        _contract.unpause(); // Unpause, as paused initially
        assertTrue(!_contract.paused());

        _contract.pause();
        assertTrue(_contract.paused());
    }

    function testUnpauses() public {
        assertTrue(_contract.paused());

        _contract.unpause();
        assertTrue(!_contract.paused());
    }

    function testCannotPauseWhenAlreadyPaused() public {
        assertTrue(_contract.paused());
        cheats.expectRevert("Pausable: paused");
        _contract.pause();
    }

    function testCannotUnpauseWhenAlreadyUnpaused() public {
        assertTrue(_contract.paused());
        _contract.unpause();

        cheats.expectRevert("Pausable: not paused");
        _contract.unpause();
    }

//    function testCannotTransferTokenWhenPaused() public {
//        address a = address(1);
//        address b = address(2);
//        _contract.transferFrom(a, b, 1);
//    }
}