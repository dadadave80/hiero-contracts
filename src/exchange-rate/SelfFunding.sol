// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import "./IExchangeRate.sol";

abstract contract SelfFunding {
    uint256 constant TINY_PARTS_PER_WHOLE = 100_000_000;
    address constant PRECOMPILE_ADDRESS = address(0x168);

    function tinycentsToTinybars(uint256 tinycents) internal returns (uint256 tinybars) {
        try IExchangeRate(PRECOMPILE_ADDRESS).tinycentsToTinybars(tinycents) returns (uint256 tinybars_) {
            return tinybars_;
        } catch {
            revert();
        }
    }

    function tinybarsToTinycents(uint256 tinybars) internal returns (uint256 tinycents) {
        try IExchangeRate(PRECOMPILE_ADDRESS).tinybarsToTinycents(tinybars) returns (uint256 tinycents_) {
            return tinycents_;
        } catch {
            revert();
        }
    }

    modifier costsCents(uint256 cents) {
        uint256 tinycents = cents * TINY_PARTS_PER_WHOLE;
        uint256 requiredTinybars = tinycentsToTinybars(tinycents);
        require(msg.value >= requiredTinybars);
        _;
    }
}
