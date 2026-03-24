// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {ExchangeRateMock, IExchangeRate} from "hiero-contracts/exchange-rate/ExchangeRateMock.sol";

contract ExchangeRateMockTest is BaseTest {
    ExchangeRateMock exchangeRateContract;

    event TinyBars(uint256 tinybars);
    event TinyCents(uint256 tinycents);

    function setUp() public override {
        super.setUp();
        exchangeRateContract = new ExchangeRateMock();
    }

    function test_ConvertTinycentsToTinybars() public {
        uint256 amountToConvert = 100000000;
        uint256 expectedTinybars = 200000000;

        // Mock the precompile call
        vm.mockCall(
            EXCHANGE_RATE_PRECOMPILE,
            abi.encodeWithSelector(IExchangeRate.tinycentsToTinybars.selector, amountToConvert),
            abi.encode(expectedTinybars)
        );

        // Expect the event to be emitted
        // Event definition: event TinyBars(uint256 tinybars);
        // We only care that the first (unindexed) parameter is emitted, and we don't know the exact current rate
        vm.recordLogs();

        exchangeRateContract.convertTinycentsToTinybars(amountToConvert);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("TinyBars(uint256)"));

        // Assert that the returned tinybars is > 0
        uint256 returnedTinybars = abi.decode(entries[0].data, (uint256));
        assertEq(returnedTinybars, expectedTinybars, "Tinybars should match expected mock value");
    }

    function test_ConvertTinybarsToTinycents() public {
        uint256 amountToConvert = 100000000;
        uint256 expectedTinycents = 50000000;

        // Mock the precompile call
        vm.mockCall(
            EXCHANGE_RATE_PRECOMPILE,
            abi.encodeWithSelector(IExchangeRate.tinybarsToTinycents.selector, amountToConvert),
            abi.encode(expectedTinycents)
        );

        vm.recordLogs();

        exchangeRateContract.convertTinybarsToTinycents(amountToConvert);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("TinyCents(uint256)"));

        uint256 returnedTinycents = abi.decode(entries[0].data, (uint256));
        assertEq(returnedTinycents, expectedTinycents, "Tinycents should match expected mock value");
    }
}
