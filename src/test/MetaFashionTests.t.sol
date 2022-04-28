// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./Test.t.sol";

contract MetaFashionTests is Test  {

    function setUp() public {
        _contract.unpause();
    }

    function testName() public {
        assertEq("MetaFashion", _contract.name());
    }

    function testSymbol() public {
        assertEq("MFT", _contract.symbol());
    }

    function testSetBaseURI() public {
        _contract.setBaseURI(_URI);

        // Mint a token and then check the uri
        _contract.setPhase(MetaFashion.MintPhase.Public);
        _contract.publicMint{value: 0.085 ether }(1);

        assertEq(string(abi.encodePacked(_URI, "1")), _contract.tokenURI(1));
    }

    function testSetMaxSupply() public {
        // Reduce max supply to one less than max transaction mint
        _contract.setMaxSupply(4);

        // Attempt to mint more than max supply
        _contract.setPhase(MetaFashion.MintPhase.Public);
        _cheatCodes.expectRevert(InsufficientSupply.selector);
        _contract.publicMint{value: 5 * 0.085 ether }(5);
    }

    function testCannotReduceMaxSupplyLowerThanMinted() public {
        _contract.setPhase(MetaFashion.MintPhase.Public);
        _contract.publicMint{value: 5 * 0.085 ether }(5);
        assertEq(_contract.totalSupply(), 5);

        // Attempt to reduce the max supply to size lower than minted
        _cheatCodes.expectRevert(TotalMintedExceedsMaxSupply.selector);
        _contract.setMaxSupply(4);

        // Set to current size and then check mint attempt fails
        _contract.setMaxSupply(_contract.totalSupply());
        _cheatCodes.expectRevert(InsufficientSupply.selector);
        _contract.publicMint{value: 0.085 ether }(1);
    }

    function testZeroSupply() public {
        _cheatCodes.expectRevert(InvalidSupply.selector);
        _contract.setMaxSupply(0);
    }

    function testSetPhaseAsPublic() public {

        address addr = address(1);
        uint256 value = 0.085 ether;
        _cheatCodes.deal(addr, value);

        _cheatCodes.expectRevert(PublicMintInactive.selector);
        _cheatCodes.prank(addr);
        _contract.publicMint{value: value}(1);

        _contract.setPhase(MetaFashion.MintPhase.Public);

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

        _contract.setPhase(MetaFashion.MintPhase.VIP);

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
        _contract.setPhase(MetaFashion.MintPhase.VIP);
        _cheatCodes.prank(addr);
        _cheatCodes.expectRevert(NotVIP.selector);
        _contract.vipMint{value: value}(1, new bytes32[](0));

        // Set new merkle root using hash of single address and mint successfully
        bytes32 root = keccak256(abi.encodePacked(addr));
        _contract.setVIPMerkleRoot(root);
        _cheatCodes.prank(addr);
        _contract.vipMint{value: value}(1, new bytes32[](0));
    }

    function testWithdrawal(uint256 balance) public {
        _cheatCodes.assume(balance > 0.1 ether && balance < 10000 ether);

        emit log_uint(balance);
        _cheatCodes.deal(address(_contract), balance);
        assertEq(address(_contract).balance, balance);

        _contract.withdraw();

        assertEq(address(_contract.COMMUNITY_WALLET()).balance, (balance * 550/1000));
        emit log_uint(address(_contract.COMMUNITY_WALLET()).balance);

        assertEq(address(_contract.METAFASHIONHQ_WALLET()).balance, (balance * 450/1000));
        emit log_uint(address(_contract.METAFASHIONHQ_WALLET()).balance);

        assertTrue(address(_contract).balance < 2);
        emit log_uint(address(_contract).balance);
    }

    function testWithdrawalOfLargeAmountOfEther() public {
        uint256 balance = 128937129831317239721212937129392948247498749385873862487691272328387618361;
        _cheatCodes.deal(address(_contract), balance);
        assertEq(address(_contract).balance, balance);

        _contract.withdraw();

        assertEq(
            address(_contract.COMMUNITY_WALLET()).balance, 
            70915421407224481846667115421166121536124312162230624368230199780613190098);
        assertEq(
            address(_contract.METAFASHIONHQ_WALLET()).balance, 
            58021708424092757874545821708226826711374437223643238119461072547774428262);
        assertEq(address(_contract).balance, 1); // 1 wei remainder
    }

    function testTokenIdStartsAtOne() public {
        // Mint the first token
        assertEq(0, _contract.totalSupply());
        _contract.setPhase(MetaFashion.MintPhase.Public);
        _contract.publicMint{value: 0.085 ether }(1);

        // Ensure token 0 does not exist
        _cheatCodes.expectRevert(OwnerQueryForNonexistentToken.selector);
        _contract.ownerOf(0);

        // Ensure token 1 does
        assertEq(address(this), _contract.ownerOf(1));
    }
}