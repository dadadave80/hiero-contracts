// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "./IHRC719.sol";
import "./HederaTokenService.sol";
import "./IHederaTokenService.sol";

/**
 * @dev This contract contains multiple examples highlighting the utilization of the
 * HIP-551: Batch transactions using HTS calls via HederaTokenService Precompile contract.
 * The batches rolls multiple HTS calls in one transaction that passes ACID test
 * (atomicity, consistency, isolation, and durability).
 * Read more about HIP-551 at https://hips.hedera.com/hip/hip-551
 */
contract AtomicHTS is HederaTokenService {
    /// events ///
    event BatchAssociateGrantKYCTransfer(
        int256 associateResponseCode, int256 grantKYCResponseCode, int256 transferTokenResponseCode
    );
    event BatchApproveAssociateGrantKYCTransferFrom(
        int256 transferTokenResponseCode,
        int256 approveResponseCode,
        int256 associateResponseCode,
        int256 grantKYCResponseCode,
        int256 transferFromResponseCode
    );
    event BatchUnfreezeGrantKYCTransferFreeze(
        int256 unfreezeTokenResponseCode,
        int256 grantKYCResponseCode,
        int256 transferTokenResponseCode,
        int256 freezeTokenResponseCode
    );
    event BatchWipeMintTransfer(
        int256 wipeTokenResponseCode, int256 mintTokenResponseCode, int256 transferTokenResponseCode
    );
    event BatchMintUnfreezeGrantKYCTransferFreeze(
        int256 mintTokenResponseCode,
        int256 unfreezeTokenResponseCode,
        int256 grantKYCResponseCode,
        int256 freezeTokenResponseCode
    );
    event BatchAssociateMintGrantTransfer(
        int256 associateResponseCode,
        int256 mintTokenResponseCode,
        int256 grantKYCResponseCode,
        int256 transferTokenResponseCode
    );

    /**
     * @dev associates, grant token KYC, and send an amount of fungible token to a receiver.
     * - associateToken() -> grantTokenKYC() -> transferToken()
     */
    function batchAssociateGrantKYCTransfer(address token, address sender, address receiver, int64 amount) external {
        (int256 associateResponseCode) = HederaTokenService.associateToken(receiver, token);
        require(
            associateResponseCode == HederaResponseCodes.SUCCESS
                || associateResponseCode == HederaResponseCodes.TOKEN_ALREADY_ASSOCIATED_TO_ACCOUNT,
            "Failed to associate token."
        );

        /// @notice an account needs to be granted the KYC of the HTS token for it to receive the token
        (int256 grantKYCResponseCode) = HederaTokenService.grantTokenKyc(token, receiver);
        require(grantKYCResponseCode == HederaResponseCodes.SUCCESS, "Failed to grant token KYC.");

        (int256 transferTokenResponseCode) = HederaTokenService.transferToken(token, sender, receiver, amount);
        require(transferTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to transfer token.");

        emit BatchAssociateGrantKYCTransfer(associateResponseCode, grantKYCResponseCode, transferTokenResponseCode);
    }

    /**
     * @dev grant allowance and transfer the token on behalf of the token owner
     * - approve() -> associateToken() -> grantTokenKyc() -> transferFrom()
     *
     * @notice because .approve() can only grant allowances to spender on behalf of the caller, and in this case
     *         `this contract` is the caller who makes transactions to the `precompile contract`. With the same reason,
     *         .transferFrom() will transfer the tokens from token owner to the receipient by the spender (this contract)
     *         on behalf of the token owner. Therefore, the spender in this particular case will also be the sender whose balance
     *         will be deducted by the .transferFrom() method.
     */
    function batchApproveAssociateGrantKYCTransferFrom(
        address token,
        address owner,
        address receipient,
        int64 transferAmount,
        uint256 allowance
    ) external {
        /// top up the spender with initial fund
        /// @notice it is necessary for the spender to be associated and granted token KYC to receive fund.
        address spender = address(this);
        (int256 associateContractResponseCode) = HederaTokenService.associateToken(spender, token);
        require(
            associateContractResponseCode == HederaResponseCodes.SUCCESS
                || associateContractResponseCode == HederaResponseCodes.TOKEN_ALREADY_ASSOCIATED_TO_ACCOUNT,
            "Failed to associate token."
        );

        (int256 grantKYCContractResponseCode) = HederaTokenService.grantTokenKyc(token, spender);
        require(grantKYCContractResponseCode == HederaResponseCodes.SUCCESS, "Failed to grant token KYC.");

        (int256 transferTokenResponseCode) = HederaTokenService.transferToken(token, owner, spender, transferAmount);
        require(transferTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to transfer token.");

        /// main logics

        (int256 approveResponseCode) = HederaTokenService.approve(token, spender, allowance);
        require(approveResponseCode == HederaResponseCodes.SUCCESS, "Failed to grant token allowance.");

        (int256 associateResponseCode) = HederaTokenService.associateToken(receipient, token);
        require(
            associateResponseCode == HederaResponseCodes.SUCCESS
                || associateResponseCode == HederaResponseCodes.TOKEN_ALREADY_ASSOCIATED_TO_ACCOUNT,
            "Failed to associate token."
        );

        (int256 grantKYCResponseCode) = HederaTokenService.grantTokenKyc(token, receipient);
        require(grantKYCResponseCode == HederaResponseCodes.SUCCESS, "Failed to grant token KYC.");

        (int256 transferFromResponseCode) = this.transferFrom(token, spender, receipient, allowance);
        require(transferFromResponseCode == HederaResponseCodes.SUCCESS, "Failed to transfer token.");

        emit BatchApproveAssociateGrantKYCTransferFrom(
            transferTokenResponseCode,
            approveResponseCode,
            associateResponseCode,
            grantKYCResponseCode,
            transferFromResponseCode
        );
    }

    /**
     * @dev unfreeze the token, transfers the token to receiver and freeze the token.
     * - unfreezeToken() -> grantTokenKyc() -> transferToken() -> freezeToken()
     */
    function batchUnfreezeGrantKYCTransferFreeze(address token, address sender, address receiver, int64 amount)
        external
    {
        (int256 unfreezeTokenResponseCode) = HederaTokenService.unfreezeToken(token, receiver);
        require(unfreezeTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to unfreeze token.");

        (int256 grantKYCResponseCode) = HederaTokenService.grantTokenKyc(token, receiver);
        require(grantKYCResponseCode == HederaResponseCodes.SUCCESS, "Failed to grant token KYC.");

        (int256 transferTokenResponseCode) = HederaTokenService.transferToken(token, sender, receiver, amount);
        require(transferTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to transfer token.");

        (int256 freezeTokenResponseCode) = HederaTokenService.freezeToken(token, receiver);
        require(freezeTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to freeze token.");

        emit BatchUnfreezeGrantKYCTransferFreeze(
            unfreezeTokenResponseCode, grantKYCResponseCode, transferTokenResponseCode, freezeTokenResponseCode
        );
    }

    /**
     * @dev wipes a token from token owner's balance, then mint more tokens to the treasury and finally transfer the token from treasury to the token owner.
     * - wipeTokenAccount() -> mintToken() -> transferToken()
     */
    function batchWipeMintTransfer(
        address token,
        address treasury,
        address owner,
        int64 wipedAmount,
        int64 mintAmount,
        int64 transferAmount
    ) external {
        bytes[] memory metadata;
        (int256 wipeTokenResponseCode) = HederaTokenService.wipeTokenAccount(token, owner, wipedAmount);
        require(wipeTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to wipe token.");

        (int256 mintTokenResponseCode,,) = HederaTokenService.mintToken(token, mintAmount, metadata);
        require(mintTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to mint token.");

        (int256 transferTokenResponseCode) = HederaTokenService.transferToken(token, treasury, owner, transferAmount);
        require(transferTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to transfer token.");

        emit BatchWipeMintTransfer(wipeTokenResponseCode, mintTokenResponseCode, transferTokenResponseCode);
    }

    /**
     * @dev mints new tokens to treasury, unfreeze the receiver on the token so the receiver can receive token, and finally reset the freeze status on the receiver and the token.
     * - mintToken() -> unfreezeToken() -> grantTokenKyc() -> transferToken() -> freezeToken()
     */
    function batchMintUnfreezeGrantKYCTransferFreeze(
        address token,
        address sender,
        address receiver,
        int64 mintAmount,
        int64 transferAmount
    ) external {
        bytes[] memory metadata;
        (int256 mintTokenResponseCode,,) = HederaTokenService.mintToken(token, mintAmount, metadata);
        require(mintTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to mint token.");

        (int256 unfreezeTokenResponseCode) = HederaTokenService.unfreezeToken(token, receiver);
        require(unfreezeTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to unfreeze token.");

        (int256 grantKYCResponseCode) = HederaTokenService.grantTokenKyc(token, receiver);
        require(grantKYCResponseCode == HederaResponseCodes.SUCCESS, "Failed to grant token KYC.");

        (int256 transferTokenResponseCode) = HederaTokenService.transferToken(token, sender, receiver, transferAmount);
        require(transferTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to transfer token.");

        (int256 freezeTokenResponseCode) = HederaTokenService.freezeToken(token, receiver);
        require(freezeTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to freeze token.");

        emit BatchMintUnfreezeGrantKYCTransferFreeze(
            mintTokenResponseCode, unfreezeTokenResponseCode, grantKYCResponseCode, freezeTokenResponseCode
        );
    }

    /**
     * @dev associate the token with receiver, then mint new token on treasury and transfer the new minted tokens to receiver
     * - associateToken() -> mintToken() -> grantTokenKyc() -> transferToken()
     */
    function batchAssociateMintGrantTransfer(address token, address sender, address receiver, int64 amount) external {
        (int256 associateResponseCode) = HederaTokenService.associateToken(receiver, token);
        require(
            associateResponseCode == HederaResponseCodes.SUCCESS
                || associateResponseCode == HederaResponseCodes.TOKEN_ALREADY_ASSOCIATED_TO_ACCOUNT,
            "Failed to associate token."
        );

        bytes[] memory metadata;
        (int256 mintTokenResponseCode,,) = HederaTokenService.mintToken(token, amount, metadata);
        require(mintTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to mint token.");

        (int256 grantKYCResponseCode) = HederaTokenService.grantTokenKyc(token, receiver);
        require(grantKYCResponseCode == HederaResponseCodes.SUCCESS, "Failed to grant token KYC.");

        (int256 transferTokenResponseCode) = HederaTokenService.transferToken(token, sender, receiver, amount);
        require(transferTokenResponseCode == HederaResponseCodes.SUCCESS, "Failed to transfer token.");

        emit BatchAssociateMintGrantTransfer(
            associateResponseCode, mintTokenResponseCode, grantKYCResponseCode, transferTokenResponseCode
        );
    }
}
