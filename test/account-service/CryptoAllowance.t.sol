// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {CryptoAllowance, IHederaTokenService} from "hiero-contracts/extensions/ihrc-906/CryptoAllowance.sol";
import {IHederaAccountService} from "hiero-contracts/account-service/IHederaAccountService.sol";

contract CryptoAllowanceTest is BaseTest {
    CryptoAllowance cryptoAllowance;

    address constant OWNER = address(0x1111);
    address constant SPENDER = address(0x2222);

    event ResponseCode(int256 responseCode);
    event HbarAllowance(address owner, address spender, int256 allowance);

    function setUp() public override {
        super.setUp();
        cryptoAllowance = new CryptoAllowance();
    }

    function test_HbarApprovePublic() public {
        vm.mockCall(
            HAS_PRECOMPILE,
            abi.encodeWithSelector(IHederaAccountService.hbarApprove.selector, OWNER, SPENDER, int256(100)),
            abi.encode(TX_SUCCESS_CODE)
        );
        vm.recordLogs();
        int64 responseCode = cryptoAllowance.hbarApprovePublic(OWNER, SPENDER, 100);

        assertEq(responseCode, int64(TX_SUCCESS_CODE));

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("ResponseCode(int256)"));
    }

    function test_HbarAllowancePublic() public {
        vm.mockCall(
            HAS_PRECOMPILE,
            abi.encodeWithSelector(IHederaAccountService.hbarAllowance.selector, OWNER, SPENDER),
            abi.encode(TX_SUCCESS_CODE, int256(500))
        );
        vm.recordLogs();
        (int64 responseCode, int256 allowance) = cryptoAllowance.hbarAllowancePublic(OWNER, SPENDER);

        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertEq(allowance, 500);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 2);
        assertEq(entries[0].topics[0], keccak256("ResponseCode(int256)"));
        assertEq(entries[1].topics[0], keccak256("HbarAllowance(address,address,int256)"));

        // Log[1] data decode logic would be needed manually since events have un-indexed strings/addresses in topics
    }

    function test_CryptoTransferPublic() public {
        IHederaTokenService.TransferList memory transferList;
        IHederaTokenService.TokenTransferList[] memory tokenTransferList =
            new IHederaTokenService.TokenTransferList[](0);

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.cryptoTransfer.selector, transferList, tokenTransferList),
            abi.encode(TX_SUCCESS_CODE)
        );

        vm.recordLogs();
        int256 responseCode = cryptoAllowance.cryptoTransferPublic(transferList, tokenTransferList);

        assertEq(responseCode, int256(TX_SUCCESS_CODE));

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("ResponseCode(int256)"));
    }
}
