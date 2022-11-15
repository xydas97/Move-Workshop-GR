module nftrpg::avatar {
    // imports
    use std::option::{Self, Option};
    use std::string::{Self, String};

    use sui::object::{Self, UID, ID};
    use sui::coin::{Self, Coin};
    use sui::tx_context::{TxContext};
    use sui::transfer;
    use sui::dynamic_object_field as ofield;

    use nftrpg::gold::GOLD;
    use nftrpg::weapon::Weapon;


    // errors
    const ENotEnoughGold: u64 = 0;
    const EAlreadyWielding: u64 = 1;
    const ENotWielding: u64 = 2;

    // structs
    struct Avatar has key {
        id: UID,
        name: String,
        gold: Coin<GOLD>,
        weapon: Option<ID>,
    }

    public entry fun create(name: vector<u8>, gold: Coin<GOLD>, recipient: address, ctx: &mut TxContext) {
        assert!(coin::value(&gold) >= 50, ENotEnoughGold);
        let avatar = Avatar {
            id: object::new(ctx),
            name: string::utf8(name),
            gold,
            weapon: option::none()
        };

        transfer::transfer(avatar, recipient);
    }

    public entry fun wield<W>(avatar: &mut Avatar, weapon: Weapon<W>) {
        assert!(option::is_none(&avatar.weapon), EAlreadyWielding);
        option::fill(&mut avatar.weapon, object::id(&weapon));
        ofield::add(&mut avatar.id, b"w", weapon);
    }

    public fun unwield<W> (avatar: &mut Avatar): Weapon<W> {
        assert!(option::is_some<ID>(&avatar.weapon), ENotWielding);
        let _ = option::extract(&mut avatar.weapon);
        ofield::remove(&mut avatar.id, b"w")
    }

    // accessors
    public fun name (avatar: &Avatar): &String {
        &avatar.name
    }

    public fun balance(avatar: &Avatar): u64 {
        coin::value(&avatar.gold)
    }
}