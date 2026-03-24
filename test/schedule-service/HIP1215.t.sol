// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest} from "../Base.t.sol";
import {HRC1215Contract} from "hiero-contracts/extensions/ihrc-1215/HRC1215Contract.sol";
import {IHRC1215ScheduleFacade} from "hiero-contracts/schedule-service/IHRC1215ScheduleFacade.sol";
import {IHRC1215} from "hiero-contracts/schedule-service/IHRC1215.sol";

contract HIP1215Test is BaseTest {
    HRC1215Contract hrc1215Contract;

    address constant TARGET_CONTRACT = address(0x1111);
    address constant PAYER = address(0x2222);
    address constant SCHEDULE_ADDRESS = address(0x3333);

    function setUp() public override {
        super.setUp();
        hrc1215Contract = new HRC1215Contract();
    }

    function test_ScheduleCallDirect() public {
        bytes memory callData = "call";
        vm.mockCall(
            HSS_PRECOMPILE,
            abi.encodeWithSelector(IHRC1215.scheduleCall.selector),
            abi.encode(TX_SUCCESS_CODE, SCHEDULE_ADDRESS)
        );
        (int64 responseCode, address scheduleAddress) =
            hrc1215Contract.scheduleCallDirect(TARGET_CONTRACT, 100, 2000000, 0, callData);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertEq(scheduleAddress, SCHEDULE_ADDRESS);
    }

    function test_ScheduleCallWithPayerDirect() public {
        bytes memory callData = "call";
        vm.mockCall(
            HSS_PRECOMPILE,
            abi.encodeWithSelector(IHRC1215.scheduleCallWithPayer.selector),
            abi.encode(TX_SUCCESS_CODE, SCHEDULE_ADDRESS)
        );
        (int64 responseCode, address scheduleAddress) =
            hrc1215Contract.scheduleCallWithPayerDirect(TARGET_CONTRACT, PAYER, 100, 2000000, 0, callData);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertEq(scheduleAddress, SCHEDULE_ADDRESS);
    }

    function test_ExecuteCallOnPayerSignatureDirect() public {
        bytes memory callData = "call";
        vm.mockCall(
            HSS_PRECOMPILE,
            abi.encodeWithSelector(IHRC1215.executeCallOnPayerSignature.selector),
            abi.encode(TX_SUCCESS_CODE, SCHEDULE_ADDRESS)
        );
        (int64 responseCode, address scheduleAddress) =
            hrc1215Contract.executeCallOnPayerSignatureDirect(TARGET_CONTRACT, PAYER, 100, 2000000, 0, callData);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertEq(scheduleAddress, SCHEDULE_ADDRESS);
    }

    function test_DeleteScheduleDirect() public {
        vm.mockCall(
            HSS_PRECOMPILE,
            abi.encodeWithSelector(IHRC1215.deleteSchedule.selector, SCHEDULE_ADDRESS),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = hrc1215Contract.deleteScheduleDirect(SCHEDULE_ADDRESS);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_DeleteScheduleProxy() public {
        vm.mockCall(
            SCHEDULE_ADDRESS,
            abi.encodeWithSelector(IHRC1215ScheduleFacade.deleteSchedule.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = hrc1215Contract.deleteScheduleProxy(SCHEDULE_ADDRESS);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_HasScheduleCapacityProxy() public {
        vm.mockCall(
            HSS_PRECOMPILE,
            abi.encodeWithSelector(IHRC1215.hasScheduleCapacity.selector, 100, 2000000),
            abi.encode(true)
        );
        // Note: HederaScheduleService decodes abi.decode(result, (bool)) for hasScheduleCapacity
        // It does not include int32 in the return. So abi.encode(true) is correct.
        bool hasCapacity = hrc1215Contract.hasScheduleCapacityProxy(100, 2000000);
        assertTrue(hasCapacity);
    }
}
