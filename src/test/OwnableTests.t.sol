// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Test.t.sol";

contract OwnableTests is Test {

    function testCannotPauseAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.pause();
    }

    function testCannotUnpauseAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.unpause();
    }

    function testCannotSetBaseURIAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.setBaseURI(_URI);
    }

    function testCannotSetPhaseAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.setPhase(MetaFashion.Phase.VIP);
    }

    function testCannotSetVIPMerkleRootAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.setVIPMerkleRoot(_VIP_MERKLE_ROOT);
    }
}