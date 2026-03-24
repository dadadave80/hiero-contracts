// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {PrngSystemContract, IPrngSystemContract} from "hiero-contracts/prng/PrngSystemContract.sol";

contract PrngSystemContractTest is BaseTest {
    PrngSystemContract prngContract;

    event PseudoRandomSeed(bytes32 seedBytes);

    function setUp() public override {
        super.setUp();
        prngContract = new PrngSystemContract();
    }

    function test_GetPseudorandomSeed() public {
        bytes32 expectedSeed = keccak256(abi.encodePacked("pseudo_random_seed"));

        // Mock the PRNG precompile call
        vm.mockCall(
            PRNG_PRECOMPILE,
            abi.encodeWithSelector(IPrngSystemContract.getPseudorandomSeed.selector),
            abi.encode(expectedSeed)
        );

        vm.recordLogs();

        prngContract.getPseudorandomSeed();

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("PseudoRandomSeed(bytes32)"));

        bytes32 seed = abi.decode(entries[0].data, (bytes32));
        assertEq(seed, expectedSeed, "Random seed should match expected mock value");
    }
}
