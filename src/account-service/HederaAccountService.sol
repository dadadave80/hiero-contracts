// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

import {HederaResponseCodes} from "hiero-contracts/common/HederaResponseCodes.sol";
import {IHederaAccountService} from "hiero-contracts/account-service/IHederaAccountService.sol";

abstract contract HederaAccountService {
    address constant HAS_PRECOMPILE = address(0x16a);

    /// Returns the amount of hbars that the spender has been authorized to spend on behalf of the owner.
    /// @param owner The account that has authorized the spender
    /// @param spender The account that has been authorized by the owner
    /// @return responseCode The response code for the status of the request. SUCCESS is 22.
    /// @return amount The amount of hbar that the spender has been authorized to spend on behalf of the owner.
    function hbarAllowance(address owner, address spender) internal returns (int64 responseCode, int256 amount) {
        try IHederaAccountService(HAS_PRECOMPILE).hbarAllowance(owner, spender) returns (
            int64 responseCode_, int256 amount_
        ) {
            return (responseCode_, amount_);
        } catch {
            return (HederaResponseCodes.UNKNOWN, (int256)(0));
        }
    }

    /// Allows spender to withdraw hbars from the owner account multiple times, up to the value amount. If this function is called
    /// again it overwrites the current allowance with the new amount.
    /// @param owner The owner of the hbars
    /// @param spender the account address authorized to spend
    /// @param amount the amount of hbars authorized to spend.
    /// @return responseCode The response code for the status of the request. SUCCESS is 22.
    function hbarApprove(address owner, address spender, int256 amount) internal returns (int64 responseCode) {
        try IHederaAccountService(HAS_PRECOMPILE).hbarApprove(owner, spender, amount) returns (int64 responseCode_) {
            return responseCode_;
        } catch {
            return HederaResponseCodes.UNKNOWN;
        }
    }

    /// Returns the EVM address alias for a given Hedera account.
    /// @param accountNumAlias The Hedera account number alias to lookup. Must satisfy all of the following:
    ///                         - Must be in long-zero format (0x000...0<account_num>)
    ///                         - Must reference an existing Hedera account
    ///                         - Referenced account must have an associated EVM address alias
    /// @return responseCode The response code indicating the status of the request:
    ///                         - SUCCESS (22) if successful
    ///                         - INVALID_ACCOUNT_ID (15) if any validation of the accountNumAlias fails
    ///                         - UNKNOWN (21) if the precompile call fails
    /// @return evmAddressAlias The EVM address alias associated with the Hedera account, or address(0) if the request fails
    function getEvmAddressAlias(address accountNumAlias)
        internal
        returns (int64 responseCode, address evmAddressAlias)
    {
        try IHederaAccountService(HAS_PRECOMPILE).getEvmAddressAlias(accountNumAlias) returns (
            int64 responseCode_, address evmAddressAlias_
        ) {
            return (responseCode_, evmAddressAlias_);
        } catch {
            return (HederaResponseCodes.UNKNOWN, address(0));
        }
    }

    /// Returns the Hedera Account ID (as account num alias) for the given EVM address alias
    /// @param evmAddressAlias The EVM address alias to get the Hedera account for. Must satisfy all of the following:
    ///                         - Must be in EVM format (not a long-zero address)
    ///                         - Must reference an existing Hedera account
    ///                         - Referenced account must have an associated account num alias (long-zero format)
    /// @return responseCode The response code indicating the status of the request:
    ///                         - SUCCESS (22) if successful
    ///                         - INVALID_SOLIDITY_ADDRESS (29) if any validation of the evmAddressAlias fails
    ///                         - UNKNOWN (21) if the precompile call fails
    /// @return accountNumAlias The Hedera account's num alias in long-zero format, or address(0) if the request fails
    function getHederaAccountNumAlias(address evmAddressAlias)
        internal
        returns (int64 responseCode, address accountNumAlias)
    {
        try IHederaAccountService(HAS_PRECOMPILE).getHederaAccountNumAlias(evmAddressAlias) returns (
            int64 responseCode_, address accountNumAlias_
        ) {
            return (responseCode_, accountNumAlias_);
        } catch {
            return (HederaResponseCodes.UNKNOWN, address(0));
        }
    }

    /// Returns true iff a Hedera account num alias or EVM address alias.
    /// @param addr Some 20-byte address.
    /// @return responseCode The response code for the status of the request. SUCCESS is 22.
    /// @return response true iff addr is a Hedera account num alias or an EVM address alias (and false otherwise).
    function isValidAlias(address addr) internal returns (int64 responseCode, bool response) {
        try IHederaAccountService(HAS_PRECOMPILE).isValidAlias(addr) returns (int64 responseCode_, bool response_) {
            return (responseCode_, response_);
        } catch {
            return (HederaResponseCodes.UNKNOWN, false);
        }
    }

    /// Determines if the signature is valid for the given message hash and account.
    /// It is assumed that the signature is composed of a single EDCSA or ED25519 key.
    /// @param account The account to check the signature against
    /// @param messageHash The hash of the message to check the signature against
    /// @param signature The signature to check
    /// @return responseCode The response code for the status of the request. SUCCESS is 22.
    /// @return authorized True if the signature is valid, false otherwise
    function isAuthorizedRaw(address account, bytes memory messageHash, bytes memory signature)
        internal
        returns (int64 responseCode, bool authorized)
    {
        try IHederaAccountService(HAS_PRECOMPILE).isAuthorizedRaw(account, messageHash, signature) returns (
            int64 responseCode_, bool authorized_
        ) {
            return (responseCode_, authorized_);
        } catch {
            return (HederaResponseCodes.UNKNOWN, false);
        }
    }

    /// Determines if the signature is valid for the given message and account.
    /// It is assumed that the signature is composed of a possibly complex cryptographic key.
    /// @param account The account to check the signature against.
    /// @param message The message to check the signature against.
    /// @param signature The signature to check encoded as bytes.
    /// @return responseCode The response code for the status of the request.  SUCCESS is 22.
    /// @return authorized True if the signature is valid, false otherwise.
    function isAuthorized(address account, bytes memory message, bytes memory signature)
        internal
        returns (int64 responseCode, bool authorized)
    {
        try IHederaAccountService(HAS_PRECOMPILE).isAuthorized(account, message, signature) returns (
            int64 responseCode_, bool authorized_
        ) {
            return (responseCode_, authorized_);
        } catch {
            return (HederaResponseCodes.UNKNOWN, false);
        }
    }
}
