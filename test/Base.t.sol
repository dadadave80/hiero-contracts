// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract BaseTest is Test {
    // Hedera Precompile Addresses
    address constant HTS_PRECOMPILE = address(0x167);
    address constant EXCHANGE_RATE_PRECOMPILE = address(0x168);
    address constant PRNG_PRECOMPILE = address(0x169);
    address constant HAS_PRECOMPILE = address(0x16a);
    address constant HSS_PRECOMPILE = address(0x16b);

    // Common Response Codes
    int64 constant TX_SUCCESS_CODE = 22;

    // Gas Limits matching Hardhat tests
    uint256 constant GAS_LIMIT_1_000_000 = 1_000_000;
    uint256 constant GAS_LIMIT_10_000_000 = 10_000_000;

    function setUp() public virtual {
        // Fork Hedera Mainnet
        string memory rpcUrl = vm.envOr("FOUNDRY_HEDERA_MAINNET", string("https://mainnet.hashio.io/api"));
        vm.createSelectFork(rpcUrl);
    }

    /// Helper to expect a specific HTS response code
    function expectHTSResponseCode(int64 expectedCode) internal {
        // HTS precompiles typically revert with a reason string that corresponds to the ascii hex of the response code
        // For Foundry tests, we use vm.expectRevert to catch these
        // However, many HTS responses are emitted as events or returned rather than reverting directly.
        // This helper will be expanded as we encounter specific revert patterns.
    }
}
