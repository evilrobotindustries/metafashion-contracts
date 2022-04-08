// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Test.t.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";

contract BurnableTests is Test {

    using Strings for uint256;

    function setUp() public {
        _contract.unpause();
    }

    /// @dev Use forge fuzz testing to test using random addresses
    function testOwnerCanBurnToken(uint160 mintAddress) public {
        _cheatCodes.assume(mintAddress > 0); // Zero address cannot mint
        _cheatCodes.startPrank(address(mintAddress));

        // Mint token for address and then burn
        assertEq(0, _contract.totalSupply());
        _contract.publicMint(1);
        assertEq(1, _contract.totalSupply());
        _contract.burn(1);
        assertEq(0, _contract.totalSupply());
    }

    /// @dev Use forge fuzz testing to test using random addresses
    function testCannotBurnWhenNotOwner(uint160 mintAddress, uint160 anotherAddress) public {
        _cheatCodes.assume(mintAddress > 0 && anotherAddress > 0); // Zero address cannot mint
        _cheatCodes.assume(mintAddress != anotherAddress); // Testing when addresses are different so exclude when same

        // Mint as supplied address
        _cheatCodes.prank(address(mintAddress));
        _contract.publicMint(1);

        // Attempt to burn when not owner
        _cheatCodes.prank(address(anotherAddress));
        _cheatCodes.expectRevert(TransferCallerNotOwnerNorApproved.selector);
        _contract.burn(1);
    }
}