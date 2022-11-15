module nftrpg::gold {
    // import
    use sui::coin;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    //structs
    struct GOLD has drop {}

    fun init(witness: GOLD, ctx: &mut TxContext) {
        let treasuryCap = coin::create_currency(witness, 0, ctx);
        transfer::transfer(treasuryCap, tx_context::sender(ctx));
    }
}