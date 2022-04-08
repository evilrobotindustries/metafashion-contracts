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
        _contract.publicMint(1);

        assertEq(string(abi.encodePacked(_URI, "1")), _contract.tokenURI(1));
    }

    function testPublicMint() public {
        _contract.publicMint(1);
    }

    function testVIPMint() public {
        _contract.setContractStatus(MetaFashion.ContractStatus.VIPOnly);
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = bytes32(bytes("as9d87sad98as7d98sa7d"));
        _contract.vipMint(1, proof);
    }


    function testTokenIdStartsAtOne() public {
        // Mint the first token
        assertEq(0, _contract.totalSupply());
        _contract.publicMint(1);

        // Ensure token 0 does not exist
        _cheatCodes.expectRevert(OwnerQueryForNonexistentToken.selector);
        _contract.ownerOf(0);

        // Ensure token 1 does
        assertEq(address(this), _contract.ownerOf(1));
    }

}