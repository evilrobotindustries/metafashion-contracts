// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./Test.t.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";

contract BurnableTests is Test {

    using Strings for uint256;

    uint256 private constant _PRICE = 0.085 ether;

    function setUp() public {
        _contract.unpause();
        _contract.setPhase(MetaFashion.MintPhase.Public);
    }

    /// @dev Use forge fuzz testing to test using random addresses
    function testOwnerCanBurnToken(uint160 mintAddress) public {
        // Zero and contract address cannot mint
        _cheatCodes.assume(mintAddress > 0 && mintAddress != uint160(address(_contract))); 

        address addr = address(mintAddress);
        _cheatCodes.deal(addr, _PRICE);
        _cheatCodes.startPrank(addr);

        // Mint token for address and then burn
        assertEq(0, _contract.totalSupply());
        _contract.publicMint{value: _PRICE }(1);
        assertEq(1, _contract.totalSupply());
        _contract.burn(1);
        assertEq(0, _contract.totalSupply());
    }

    /// @dev Use forge fuzz testing to test using random addresses
    function testCannotBurnWhenNotOwner(uint160 mintAddress, uint160 anotherAddress) public {
        _cheatCodes.assume(mintAddress > 0 && anotherAddress > 0); // Zero address cannot mint
        // contract address cannot mint
        _cheatCodes.assume(
            mintAddress != uint160(address(_contract)) && 
            anotherAddress != uint160(address(_contract))); 
        _cheatCodes.assume(mintAddress != anotherAddress); // Testing when addresses are different so exclude when same

        // Mint as supplied address
        address addr = address(mintAddress);
        _cheatCodes.deal(addr, _PRICE);
        _cheatCodes.prank(addr);
        _contract.publicMint{value: _PRICE }(1);

        // Attempt to burn when not owner
        _cheatCodes.prank(address(anotherAddress));
        _cheatCodes.expectRevert(TransferCallerNotOwnerNorApproved.selector);
        _contract.burn(1);
    }
}