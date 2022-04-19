// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Test.t.sol";

contract MetaFashionTests is Test  {

    function setUp() public {
        _contract.unpause();
    }

    function testName() public {
        assertEq("MetaFashion", _contract.name());
    }

    function testSymbol() public {
        assertEq("MFHQ", _contract.symbol());
    }

    function testSetBaseURI() public {
        _contract.setBaseURI(_URI);

        // Mint a token and then check the uri
        _contract.setPhase(MetaFashion.Phase.Public);
        _contract.publicMint{value: 0.085 ether }(1);

        assertEq(string(abi.encodePacked(_URI, "1")), _contract.tokenURI(1));
    }

    function testTokenIdStartsAtOne() public {
        // Mint the first token
        assertEq(0, _contract.totalSupply());
        _contract.setPhase(MetaFashion.Phase.Public);
        _contract.publicMint{value: 0.085 ether }(1);

        // Ensure token 0 does not exist
        _cheatCodes.expectRevert(OwnerQueryForNonexistentToken.selector);
        _contract.ownerOf(0);

        // Ensure token 1 does
        assertEq(address(this), _contract.ownerOf(1));
    }


    function testSetPhaseAsPublic() public {

        address addr = address(1);
        uint256 value = 0.085 ether;
        _cheatCodes.deal(addr, value);

        _cheatCodes.expectRevert(PublicMintInactive.selector);
        _cheatCodes.prank(addr);
        _contract.publicMint{value: value}(1);

        _contract.setPhase(MetaFashion.Phase.Public);

        _cheatCodes.prank(addr);
        _contract.publicMint{value: value}(1);
    }

    function testSetPhaseAsVIP() public {

        address addr = address(1);
        uint256 value = 0.075 ether;
        _cheatCodes.deal(addr, value);

        _cheatCodes.expectRevert(VIPMintInactive.selector);
        _cheatCodes.prank(addr);
        _contract.vipMint{value: value}(1, new bytes32[](0));

        _contract.setPhase(MetaFashion.Phase.VIP);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x5b70e80538acdabd6137353b0f9d8d149f4dba91e8be2e7946e409bfdbe685b9;
        proof[1] = 0xd52688a8f926c816ca1e079067caba944f158e764817b83fc43594370ca9cf62;

        _cheatCodes.prank(addr);
        _contract.vipMint{value: value}(1, proof);
    }

    function testSetVIPMerkleRoot() public {

        address addr = address(11);
        uint256 value = 0.075 ether;
        _cheatCodes.deal(addr, value);

        // Attempt to mint with default merkle root set, expecting failure as address not included
        _contract.setPhase(MetaFashion.Phase.VIP);
        _cheatCodes.prank(addr);
        _cheatCodes.expectRevert(NotVIP.selector);
        _contract.vipMint{value: value}(1, new bytes32[](0));

        // Set new merkle root using hash of single address and mint successfully
        bytes32 root = keccak256(abi.encodePacked(addr));
        _contract.setVIPMerkleRoot(root);
        _cheatCodes.prank(addr);
        _contract.vipMint{value: value}(1, new bytes32[](0));
    }
}