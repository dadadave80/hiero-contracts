// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest} from "../Base.t.sol";
import {ClaimAirdrop, IHederaTokenService} from "hiero-contracts/extensions/hrc-904/ClaimAirdrop.sol";

contract ClaimAirdropContractTest is BaseTest {
    ClaimAirdrop claimAirdropContract;
    address constant SENDER = address(0x1111);
    address constant RECEIVER = address(0x2222);
    address constant TOKEN_ADDRESS = address(0x3333);
    address constant NFT_ADDRESS = address(0x4444);

    function setUp() public override {
        super.setUp();
        claimAirdropContract = new ClaimAirdrop();
    }

    function test_Claim() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.claimAirdrops.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = claimAirdropContract.claim(SENDER, RECEIVER, TOKEN_ADDRESS);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_ClaimNFTAirdrop() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.claimAirdrops.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = claimAirdropContract.claimNFTAirdrop(SENDER, RECEIVER, NFT_ADDRESS, 1);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_ClaimMultipleAirdrops() public {
        address[] memory senders = new address[](2);
        senders[0] = SENDER;
        senders[1] = SENDER;

        address[] memory receivers = new address[](2);
        receivers[0] = RECEIVER;
        receivers[1] = RECEIVER;

        address[] memory tokens = new address[](2);
        tokens[0] = TOKEN_ADDRESS;
        tokens[1] = NFT_ADDRESS;

        int64[] memory serials = new int64[](2);
        serials[0] = 0;
        serials[1] = 1;

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.claimAirdrops.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = claimAirdropContract.claimMultipleAirdrops(senders, receivers, tokens, serials);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }
}
