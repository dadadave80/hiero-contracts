// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest} from "../Base.t.sol";
import {ERC721Contract} from "hiero-contracts/mocks/ERC721Contract.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Metadata} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract ERC721ContractTest is BaseTest {
    ERC721Contract erc721Contract;
    address constant MOCK_TOKEN = address(0x1234);
    address constant OWNER = address(0x5678);
    address constant SPENDER = address(0x9ABC);

    function setUp() public override {
        super.setUp();
        erc721Contract = new ERC721Contract();
    }

    function test_Name() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC721Metadata.name.selector), abi.encode("MockNFT"));
        string memory name = erc721Contract.name(MOCK_TOKEN);
        assertEq(name, "MockNFT");
    }

    function test_Symbol() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC721Metadata.symbol.selector), abi.encode("MNFT"));
        string memory symbol = erc721Contract.symbol(MOCK_TOKEN);
        assertEq(symbol, "MNFT");
    }

    function test_TokenURI() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC721Metadata.tokenURI.selector, 1), abi.encode("ipfs://123"));
        string memory tokenURI = erc721Contract.tokenURI(MOCK_TOKEN, 1);
        assertEq(tokenURI, "ipfs://123");
    }

    function test_BalanceOf() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC721.balanceOf.selector, OWNER), abi.encode(5));
        uint256 balance = erc721Contract.balanceOf(MOCK_TOKEN, OWNER);
        assertEq(balance, 5);
    }

    function test_OwnerOf() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC721.ownerOf.selector, 1), abi.encode(OWNER));
        address owner = erc721Contract.ownerOf(MOCK_TOKEN, 1);
        assertEq(owner, OWNER);
    }

    function test_GetApproved() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC721.getApproved.selector, 1), abi.encode(SPENDER));
        address spender = erc721Contract.getApproved(MOCK_TOKEN, 1);
        assertEq(spender, SPENDER);
    }

    function test_IsApprovedForAll() public {
        vm.mockCall(
            MOCK_TOKEN, abi.encodeWithSelector(IERC721.isApprovedForAll.selector, OWNER, SPENDER), abi.encode(true)
        );
        bool approved = erc721Contract.isApprovedForAll(MOCK_TOKEN, OWNER, SPENDER);
        assertTrue(approved);
    }
}
