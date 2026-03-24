// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {AliasAccountUtility} from "hiero-contracts/extensions/ihrc-632/AliasAccountUtility.sol";
import {IHederaAccountService} from "hiero-contracts/account-service/IHederaAccountService.sol";

contract AliasAccountUtilityTest is BaseTest {
    AliasAccountUtility aliasUtility;

    address constant ACCOUNT_NUM_ALIAS = address(0x1111);
    address constant EVM_ADDRESS_ALIAS = address(0x2222);

    event AddressAliasResponse(int64 responseCode, address evmAddressAlias);
    event IsValidAliasResponse(int64 responseCode, bool response);
    event AccountAuthorizationResponse(int64 responseCode, address account, bool response);

    function setUp() public override {
        super.setUp();
        aliasUtility = new AliasAccountUtility();
    }

    function test_GetEvmAddressAliasPublic() public {
        vm.mockCall(
            HAS_PRECOMPILE,
            abi.encodeWithSelector(IHederaAccountService.getEvmAddressAlias.selector, ACCOUNT_NUM_ALIAS),
            abi.encode(TX_SUCCESS_CODE, EVM_ADDRESS_ALIAS)
        );
        vm.recordLogs();
        (int64 responseCode, address evmAddress) = aliasUtility.getEvmAddressAliasPublic(ACCOUNT_NUM_ALIAS);

        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertEq(evmAddress, EVM_ADDRESS_ALIAS);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("AddressAliasResponse(int64,address)"));
    }

    function test_GetHederaAccountNumAliasPublic() public {
        vm.mockCall(
            HAS_PRECOMPILE,
            abi.encodeWithSelector(IHederaAccountService.getHederaAccountNumAlias.selector, EVM_ADDRESS_ALIAS),
            abi.encode(TX_SUCCESS_CODE, ACCOUNT_NUM_ALIAS)
        );
        vm.recordLogs();
        (int64 responseCode, address accountNum) = aliasUtility.getHederaAccountNumAliasPublic(EVM_ADDRESS_ALIAS);

        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertEq(accountNum, ACCOUNT_NUM_ALIAS);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("AddressAliasResponse(int64,address)"));
    }

    function test_IsValidAliasPublic() public {
        // HederaAccountService raw return for isValidAlias only decodes the bool
        vm.mockCall(
            HAS_PRECOMPILE,
            abi.encodeWithSelector(IHederaAccountService.isValidAlias.selector, ACCOUNT_NUM_ALIAS),
            abi.encode(true)
        );
        vm.recordLogs();
        (int64 responseCode, bool isValid) = aliasUtility.isValidAliasPublic(ACCOUNT_NUM_ALIAS);

        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertTrue(isValid);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("IsValidAliasResponse(int64,bool)"));
    }

    function test_IsAuthorizedRawPublic() public {
        bytes memory messageHash = "hash";
        bytes memory signature = "sig";
        // HederaAccountService raw return for isAuthorizedRaw only decodes the bool
        vm.mockCall(
            HAS_PRECOMPILE,
            abi.encodeWithSelector(
                IHederaAccountService.isAuthorizedRaw.selector, ACCOUNT_NUM_ALIAS, messageHash, signature
            ),
            abi.encode(true)
        );
        vm.recordLogs();
        (int64 responseCode, bool authorized) =
            aliasUtility.isAuthorizedRawPublic(ACCOUNT_NUM_ALIAS, messageHash, signature);

        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertTrue(authorized);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("AccountAuthorizationResponse(int64,address,bool)"));
    }

    function test_IsAuthorizedPublic() public {
        bytes memory message = "msg";
        bytes memory signature = "sig";
        // HederaAccountService decodes (int32, bool) for isAuthorized
        vm.mockCall(
            HAS_PRECOMPILE,
            abi.encodeWithSelector(IHederaAccountService.isAuthorized.selector, ACCOUNT_NUM_ALIAS, message, signature),
            abi.encode(TX_SUCCESS_CODE, true)
        );
        vm.recordLogs();
        (int64 responseCode, bool authorized) = aliasUtility.isAuthorizedPublic(ACCOUNT_NUM_ALIAS, message, signature);

        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertTrue(authorized);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("AccountAuthorizationResponse(int64,address,bool)"));
    }
}
