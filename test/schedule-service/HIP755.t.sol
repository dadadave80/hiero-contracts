// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest} from "../Base.t.sol";
import {HRC755Contract} from "hiero-contracts/extensions/ihrc-755/HRC755Contract.sol";
import {IHRC755ScheduleFacade} from "hiero-contracts/schedule-service/IHRC755ScheduleFacade.sol";
import {IHRC755} from "hiero-contracts/schedule-service/IHRC755.sol";

contract HIP755Test is BaseTest {
    HRC755Contract hrc755Contract;
    address constant SCHEDULE_ADDRESS = address(0x3333);

    function setUp() public override {
        super.setUp();
        hrc755Contract = new HRC755Contract();
    }

    function test_AuthorizeScheduleCall() public {
        vm.mockCall(
            HSS_PRECOMPILE,
            abi.encodeWithSelector(IHRC755.authorizeSchedule.selector, SCHEDULE_ADDRESS),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = hrc755Contract.authorizeScheduleCall(SCHEDULE_ADDRESS);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_SignScheduleCall() public {
        bytes memory signatureMap = "sigmap";
        vm.mockCall(
            HSS_PRECOMPILE,
            abi.encodeWithSelector(IHRC755.signSchedule.selector, SCHEDULE_ADDRESS, signatureMap),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = hrc755Contract.signScheduleCall(SCHEDULE_ADDRESS, signatureMap);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_SignScheduleFacade() public {
        vm.mockCall(
            SCHEDULE_ADDRESS,
            abi.encodeWithSelector(IHRC755ScheduleFacade.signSchedule.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = IHRC755ScheduleFacade(SCHEDULE_ADDRESS).signSchedule();
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }
}
