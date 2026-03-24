// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest} from "../Base.t.sol";
import {TokenManagementContract} from "hiero-contracts/extensions/token-manage/TokenManagementContract.sol";
import {IHederaTokenService} from "hiero-contracts/token-service/IHederaTokenService.sol";

contract TokenManagementContractTest is BaseTest {
    TokenManagementContract tokenManagementContract;
    address constant MOCK_TOKEN = address(0x1234);

    function setUp() public override {
        super.setUp();
        tokenManagementContract = new TokenManagementContract();
    }

    function mockHTSResponse(bytes4 selector) internal {
        bytes memory successReturn = abi.encode(int64(TX_SUCCESS_CODE));
        vm.mockCall(HTS_PRECOMPILE, abi.encodeWithSelector(selector), successReturn);
    }

    function test_WipeTokenAccount() public {
        mockHTSResponse(IHederaTokenService.wipeTokenAccount.selector);
        int256 responseCode = tokenManagementContract.wipeTokenAccountPublic(MOCK_TOKEN, address(this), 100);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_WipeTokenAccountNFT() public {
        mockHTSResponse(IHederaTokenService.wipeTokenAccountNFT.selector);

        int64[] memory serialNumbers = new int64[](1);
        serialNumbers[0] = 1;

        int256 responseCode =
            tokenManagementContract.wipeTokenAccountNFTPublic(MOCK_TOKEN, address(this), serialNumbers);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_FreezeToken() public {
        mockHTSResponse(IHederaTokenService.freezeToken.selector);
        int256 responseCode = tokenManagementContract.freezeTokenPublic(MOCK_TOKEN, address(this));
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_UnfreezeToken() public {
        mockHTSResponse(IHederaTokenService.unfreezeToken.selector);
        int256 responseCode = tokenManagementContract.unfreezeTokenPublic(MOCK_TOKEN, address(this));
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_RevokeTokenKyc() public {
        mockHTSResponse(IHederaTokenService.revokeTokenKyc.selector);
        int256 responseCode = tokenManagementContract.revokeTokenKycPublic(MOCK_TOKEN, address(this));
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_PauseToken() public {
        mockHTSResponse(IHederaTokenService.pauseToken.selector);
        int256 responseCode = tokenManagementContract.pauseTokenPublic(MOCK_TOKEN);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_UnpauseToken() public {
        mockHTSResponse(IHederaTokenService.unpauseToken.selector);
        int256 responseCode = tokenManagementContract.unpauseTokenPublic(MOCK_TOKEN);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }
}
