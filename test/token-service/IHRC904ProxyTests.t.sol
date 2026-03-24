// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest} from "../Base.t.sol";
import {IHRC904AccountFacade} from "hiero-contracts/account-service/IHRC904AccountFacade.sol";
import {IHRC904TokenFacade} from "hiero-contracts/token-service/IHRC904TokenFacade.sol";

contract IHRC904ProxyTests is BaseTest {
    address constant TOKEN_ADDRESS = address(0x1111);
    address constant ACCOUNT_ADDRESS = address(0x2222);
    address constant OTHER_ADDRESS = address(0x3333);

    function setUp() public override {
        super.setUp();
    }

    // IHRC904TokenFacade tests
    function test_CancelAirdropFT() public {
        vm.mockCall(
            TOKEN_ADDRESS,
            abi.encodeWithSelector(IHRC904TokenFacade.cancelAirdropFT.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = IHRC904TokenFacade(TOKEN_ADDRESS).cancelAirdropFT(OTHER_ADDRESS);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_CancelAirdropNFT() public {
        vm.mockCall(
            TOKEN_ADDRESS,
            abi.encodeWithSelector(IHRC904TokenFacade.cancelAirdropNFT.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = IHRC904TokenFacade(TOKEN_ADDRESS).cancelAirdropNFT(OTHER_ADDRESS, 1);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_ClaimAirdropFT() public {
        vm.mockCall(
            TOKEN_ADDRESS,
            abi.encodeWithSelector(IHRC904TokenFacade.claimAirdropFT.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = IHRC904TokenFacade(TOKEN_ADDRESS).claimAirdropFT(OTHER_ADDRESS);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_ClaimAirdropNFT() public {
        vm.mockCall(
            TOKEN_ADDRESS,
            abi.encodeWithSelector(IHRC904TokenFacade.claimAirdropNFT.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = IHRC904TokenFacade(TOKEN_ADDRESS).claimAirdropNFT(OTHER_ADDRESS, 1);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_RejectTokenFT() public {
        vm.mockCall(
            TOKEN_ADDRESS,
            abi.encodeWithSelector(IHRC904TokenFacade.rejectTokenFT.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = IHRC904TokenFacade(TOKEN_ADDRESS).rejectTokenFT();
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_RejectTokenNFTs() public {
        vm.mockCall(
            TOKEN_ADDRESS,
            abi.encodeWithSelector(IHRC904TokenFacade.rejectTokenNFTs.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64[] memory serials = new int64[](1);
        serials[0] = 1;
        int64 responseCode = IHRC904TokenFacade(TOKEN_ADDRESS).rejectTokenNFTs(serials);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    // IHRC904AccountFacade tests
    function test_SetUnlimitedAutomaticAssociations_True() public {
        vm.mockCall(
            ACCOUNT_ADDRESS,
            abi.encodeWithSelector(IHRC904AccountFacade.setUnlimitedAutomaticAssociations.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = IHRC904AccountFacade(ACCOUNT_ADDRESS).setUnlimitedAutomaticAssociations(true);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_SetUnlimitedAutomaticAssociations_False() public {
        vm.mockCall(
            ACCOUNT_ADDRESS,
            abi.encodeWithSelector(IHRC904AccountFacade.setUnlimitedAutomaticAssociations.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = IHRC904AccountFacade(ACCOUNT_ADDRESS).setUnlimitedAutomaticAssociations(false);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }
}
