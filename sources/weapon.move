module nftrpg::weapon {
    // imports
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;

    // structs

    struct Weapon<phantom T> has key, store {
        id: UID,
        dmg: u64,
    }

    struct Axe {}
    struct Sword {}
    struct Bow {}

    public fun create_axe (ctx: &mut TxContext): Weapon<Axe> {
        let new_axe = Weapon<Axe> {
            id: object::new(ctx),
            dmg: 256,
        };
        new_axe
    }
    public fun create_sword (ctx: &mut TxContext): Weapon<Sword> {
        Weapon<Sword> {
            id: object::new(ctx),
            dmg: 238,
        }
    }
    public fun create_bow (ctx: &mut TxContext): Weapon<Bow> {
        Weapon<Bow> {
            id: object::new(ctx),
            dmg: 321,
        }
    }

    public fun dmg<W>(weapon: &Weapon<W>): u64 {
        weapon.dmg
    }

    public entry fun get_weapon (type: u8, recipient: address, ctx: &mut TxContext) {
        if (type == 0) {
            let axe = create_axe(ctx);
            transfer::transfer(axe, recipient);
        };
        if (type == 1) {
            let sword = create_sword(ctx);
            transfer::transfer(sword, recipient);
        };
        if (type == 2) {
            let bow = create_bow(ctx);
            transfer::transfer(bow, recipient);
        };
    }

}