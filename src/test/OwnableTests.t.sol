// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./Test.t.sol";

contract OwnableTests is Test {

    function testCannotMintGiveawayAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.giveawayMint();
    }

    function testCannotPauseAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.pause();
    }

    function testCannotSetBaseURIAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.setBaseURI(_URI);
    }

    function testCannotSetCollectionSizeAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.setCollectionSize(5);
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

    function testCannotUnpauseAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.unpause();
    }

    function testCannotWithdrawAsNonOwner() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert("Ownable: caller is not the owner");
        _contract.withdraw();
    }
}