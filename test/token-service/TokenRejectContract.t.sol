// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {TokenReject, IHederaTokenService} from "hiero-contracts/extensions/hrc-904/TokenReject.sol";

contract TokenRejectContractTest is BaseTest {
    TokenReject tokenRejectContract;
    address constant REJECTING_ADDRESS = address(0x1111);
    address constant FT_ADDRESS = address(0x2222);
    address constant NFT_ADDRESS = address(0x3333);

    function setUp() public override {
        super.setUp();
        tokenRejectContract = new TokenReject();
    }

    function test_RejectTokens() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.rejectTokens.selector),
            abi.encode(TX_SUCCESS_CODE)
        );

        address[] memory ftAddresses = new address[](1);
        ftAddresses[0] = FT_ADDRESS;

        address[] memory nftAddresses = new address[](1);
        nftAddresses[0] = NFT_ADDRESS;

        int64 responseCode = tokenRejectContract.rejectTokens(REJECTING_ADDRESS, ftAddresses, nftAddresses);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }
}
