// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {
    TokenCreateContract,
    IHederaTokenService
} from "hiero-contracts/extensions/token-create/TokenCreateContract.sol";

contract RedirectForTokenTest is BaseTest {
    TokenCreateContract tokenCreateContract;
    address constant MOCK_TOKEN = address(0x1234);

    event CallResponseEvent(bool arg1, bytes arg2);

    function setUp() public override {
        super.setUp();
        tokenCreateContract = new TokenCreateContract();
    }

    function test_RedirectForToken_Name() public {
        bytes memory encodedName = abi.encodeWithSignature("name()");
        bytes memory successReturn = abi.encode("MockToken");

        // redirectForToken passes the encoded selector to the HTS precompile
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.redirectForToken.selector, MOCK_TOKEN, encodedName),
            successReturn
        );

        vm.recordLogs();
        (int256 responseCode, bytes memory response) = tokenCreateContract.redirectForToken(MOCK_TOKEN, encodedName);

        assertEq(responseCode, TX_SUCCESS_CODE);
        assertEq(abi.decode(response, (string)), "MockToken");

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("CallResponseEvent(bool,bytes)"));
    }

    function test_RedirectForToken_Symbol() public {
        bytes memory encodedSymbol = abi.encodeWithSignature("symbol()");
        bytes memory successReturn = abi.encode("MCK");

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.redirectForToken.selector, MOCK_TOKEN, encodedSymbol),
            successReturn
        );

        (int256 responseCode, bytes memory response) = tokenCreateContract.redirectForToken(MOCK_TOKEN, encodedSymbol);

        assertEq(responseCode, TX_SUCCESS_CODE);
        assertEq(abi.decode(response, (string)), "MCK");
    }
}
