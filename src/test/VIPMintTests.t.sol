// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Test.t.sol";

contract VIPMintTests is Test  {

    uint256 private constant _PRICE = 0.075 ether;

    function setUp() public {
        _contract.unpause();
        _contract.setPhase(MetaFashion.Phase.VIP);
    }

    function testCannotMintWhenVIPMintingInactive() public {
        _contract.setPhase(MetaFashion.Phase.None);

        _cheatCodes.expectRevert(VIPMintInactive.selector);
        _contract.vipMint(1, new bytes32[](0));
    }

    function testCannotMintWhenQuantityExceedsMaxMint() public {
        _cheatCodes.expectRevert(TransactionMintLimitExceeded.selector);
        _contract.vipMint(4, new bytes32[](0));
    }

    function testCannotMintZeroQuantity() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x5b70e80538acdabd6137353b0f9d8d149f4dba91e8be2e7946e409bfdbe685b9;
        proof[1] = 0xd52688a8f926c816ca1e079067caba944f158e764817b83fc43594370ca9cf62;

        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert(MintZeroQuantity.selector);
        _contract.vipMint(0, proof);
    }

    function testCannotMintMoreThanOnce() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x5b70e80538acdabd6137353b0f9d8d149f4dba91e8be2e7946e409bfdbe685b9;
        proof[1] = 0xd52688a8f926c816ca1e079067caba944f158e764817b83fc43594370ca9cf62;

        // Fund address and mint max
        uint256 value = 3 * _PRICE;
        address addr = address(1);
        _cheatCodes.deal(addr, value * 2);
        _cheatCodes.startPrank(addr);
        _contract.vipMint{value: value}(3, proof);

        // Attempt a second mint
        _cheatCodes.expectRevert(TransactionLimitExceeded.selector);
        _contract.vipMint{value: value}(3, proof);
    }

    function testCannotMintWhenIncorrectValueSent() public {
        _cheatCodes.expectRevert(IncorrectValue.selector);
        _contract.vipMint(3, new bytes32[](0));
    }

    function testCannotExceedCollectionSize() public {
        
        // Public mint until supply near exhaustion 
        // (merkle proofs required for VIP mint and limited to one transaction per wallet)
        _contract.setPhase(MetaFashion.Phase.Public);
        uint256 value = 5 * 0.085 ether;
        for (uint160 a = 1; a <= 10000 / 5; a++){
            // Fund address
            address addr = address(a);
            _cheatCodes.deal(addr, value);
            _cheatCodes.prank(addr);
            _contract.publicMint{value: value}(5);
        }

        assertEq(_contract.totalSupply(), 10000);

        // Switch to VIP and attempt VIP mint
        _contract.setPhase(MetaFashion.Phase.VIP);
        
        _cheatCodes.deal(address(1), 3 * _PRICE);
        _cheatCodes.prank(address(1));
        
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x5b70e80538acdabd6137353b0f9d8d149f4dba91e8be2e7946e409bfdbe685b9;
        proof[1] = 0xd52688a8f926c816ca1e079067caba944f158e764817b83fc43594370ca9cf62;

        _cheatCodes.expectRevert(InsufficientSupply.selector);
        _contract.vipMint{value: 3 * _PRICE}(3, proof);
    }

    function testMint1() public { mint(1); }

    function testMint2() public { mint(2); }

    function testMint3() public { mint(3); }

    function mint(uint8 quantity) public {
        address addr = address(1);
        emit log_address(addr);
        emit log_bytes32(keccak256(abi.encodePacked(addr)));

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x5b70e80538acdabd6137353b0f9d8d149f4dba91e8be2e7946e409bfdbe685b9;
        proof[1] = 0xd52688a8f926c816ca1e079067caba944f158e764817b83fc43594370ca9cf62;

        // Fund address and mint max
        uint256 value = quantity * _PRICE;
        _cheatCodes.deal(addr, value);
        _cheatCodes.prank(addr);
        _contract.vipMint{value: value}(quantity, proof);
        assertEq(addr.balance, 0);

        // Ensure contract updated
        assertEq(_contract.totalSupply(), quantity);
        assertEq(address(_contract).balance, value);
    }
}