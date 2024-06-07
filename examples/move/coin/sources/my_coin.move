// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module examples::my_coin {
    use sui::coin::{Self, TreasuryCap};

    // The type identifier of coin. The coin will have a type
    // tag of kind: `Coin<package_object::mycoin::MYCOIN>`
    // Make sure that the name of the type matches the module's name.
    public struct MY_COIN has drop {}

    // Module initializer is called once on module publish. A treasury
    // cap is sent to the publisher, who then controls minting and burning.
    // Use #[allow(lint(share_owned))] to create editable metadata.
    #[allow(lint(share_owned))]
    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(witness, 6, b"MY_COIN", b"", b"", option::none(), ctx);
        // Share the metadata object so that it can be edited. You could instead 
        // prevent updates to the icon_url and other metadata with public_freeze_object.
        transfer::public_share_object(metadata);
        transfer::public_transfer(treasury, ctx.sender())
    }

    // Create MY_COINs using the TreasuryCap.
    public fun mint(
        treasury_cap: &mut TreasuryCap<MY_COIN>, 
        amount: u64, 
        recipient: address, 
        ctx: &mut TxContext,
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient)
    }
}