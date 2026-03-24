// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {TokenCreateContract} from "hiero-contracts/extensions/token-create/TokenCreateContract.sol";
import {IHederaTokenService} from "hiero-contracts/token-service/IHederaTokenService.sol";

contract TokenCreateContractTest is BaseTest {
    TokenCreateContract tokenCreateContract;
    address constant MOCK_TOKEN = address(0x1234);

    event ResponseCode(int256 responseCode);
    event CreatedToken(address token);
    event MintedToken(int64 newTotalSupply, int64[] serialNumbers);

    function setUp() public override {
        super.setUp();
        tokenCreateContract = new TokenCreateContract();
    }

    function mockHTSResponse(bytes4 selector) internal {
        // Mock a success code (22) and an optional address or supply depending on the selector
        if (
            selector == IHederaTokenService.createFungibleToken.selector
                || selector == IHederaTokenService.createFungibleTokenWithCustomFees.selector
                || selector == IHederaTokenService.createNonFungibleToken.selector
                || selector == IHederaTokenService.createNonFungibleTokenWithCustomFees.selector
        ) {
            // Token creation endpoints return (int64 responseCode, address tokenAddress)
            bytes memory successReturn = abi.encode(int64(TX_SUCCESS_CODE), MOCK_TOKEN);
            vm.mockCall(HTS_PRECOMPILE, abi.encodeWithSelector(selector), successReturn);
        } else if (selector == IHederaTokenService.mintToken.selector) {
            // Mint token returns (int64 responseCode, int64 newTotalSupply, int64[] memory serialNumbers)
            int64[] memory serials = new int64[](1);
            serials[0] = 1;
            bytes memory successReturn = abi.encode(int64(TX_SUCCESS_CODE), int64(1000), serials);
            vm.mockCall(HTS_PRECOMPILE, abi.encodeWithSelector(selector), successReturn);
        }
    }

    function test_CreateFungibleToken() public {
        mockHTSResponse(IHederaTokenService.createFungibleToken.selector);

        vm.recordLogs();
        tokenCreateContract.createFungibleTokenPublic(address(this));

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("CreatedToken(address)"));
        address tokenAddress = abi.decode(entries[0].data, (address));
        assertEq(tokenAddress, MOCK_TOKEN);
    }

    function test_MintToken() public {
        mockHTSResponse(IHederaTokenService.mintToken.selector);

        bytes[] memory metadata = new bytes[](0);

        vm.recordLogs();
        (int256 responseCode, int64 newTotalSupply, int64[] memory serialNumbers) =
            tokenCreateContract.mintTokenPublic(MOCK_TOKEN, 100, metadata);

        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertEq(newTotalSupply, 1000);
        assertEq(serialNumbers.length, 1);
        assertEq(serialNumbers[0], 1);
    }
}
