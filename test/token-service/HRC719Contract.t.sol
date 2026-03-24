// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {HRC719Contract} from "hiero-contracts/mocks/HRC719Contract.sol";
import {IHRC719} from "hiero-contracts/token-service/IHRC719.sol";

contract HRC719ContractTest is BaseTest {
    HRC719Contract hrc719Contract;
    address constant MOCK_TOKEN = address(0x1234);

    event IsAssociated(bool status);

    function setUp() public override {
        super.setUp();
        hrc719Contract = new HRC719Contract();
    }

    function test_Associate() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IHRC719.associate.selector), abi.encode(TX_SUCCESS_CODE));
        uint256 responseCode = hrc719Contract.associate(MOCK_TOKEN);
        assertEq(responseCode, uint256(int256(TX_SUCCESS_CODE)));
    }

    function test_Dissociate() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IHRC719.dissociate.selector), abi.encode(TX_SUCCESS_CODE));
        uint256 responseCode = hrc719Contract.dissociate(MOCK_TOKEN);
        assertEq(responseCode, uint256(int256(TX_SUCCESS_CODE)));
    }

    function test_IsAssociated() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IHRC719.isAssociated.selector), abi.encode(true));
        vm.recordLogs();
        hrc719Contract.isAssociated(MOCK_TOKEN);
        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("IsAssociated(bool)"));
        bool status = abi.decode(entries[0].data, (bool));
        assertTrue(status);
    }
}
