module nftrpg::shop {
    // imports
    use sui::coin::{Self, Coin};
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};
    use std::vector;
    use sui::transfer;

    use nftrpg::gold::GOLD;
    use nftrpg::weapon::{Self, Weapon, Axe, Sword, Bow};


    const AXE_PRICE: u64 = 100;
    // errors
    const EGoldNotExact: u64 = 0;
    // structs

    struct ShopAdmin has key {
        id: UID
    }

    struct Shop has key {
        id: UID,
        balance: Balance<GOLD>,
        axes: vector<Weapon<Axe>>,
        swords: vector<Weapon<Sword>>,
        bows: vector<Weapon<Bow>>,
    }

    struct Invoice {
        value: u64
    }

    fun init(ctx: &mut TxContext) {
        let cap = ShopAdmin {
            id: object::new(ctx),
        };
        transfer::transfer(cap, tx_context::sender(ctx));
        let shop = Shop {
            id: object::new(ctx),
            balance: balance::zero<GOLD>(),
            axes: vector::empty(),
            swords: vector::empty(),
            bows: vector::empty()
        };
        transfer::share_object(shop);
    }

    // owner functions
    // public entry fun withdraw_earnings(_: &mut ShopAdmin, shop: &Shop, ctx: &mut TxContext) {
    //     let earnings = coin::from_balance(&mut shop.balance, ctx);
    //     transfer::transfer(earnings, tx_context::sender(ctx));
    // }

    public entry fun stock_axe(_: &mut ShopAdmin, shop: &mut Shop, ctx: &mut TxContext) {
        let axe = weapon::create_axe(ctx);
        vector::push_back(&mut shop.axes, axe);
    }

    public entry fun stock_sword(_: &mut ShopAdmin, shop: &mut Shop, ctx: &mut TxContext) {
        let sword = weapon::create_sword(ctx);
        vector::push_back(&mut shop.swords, sword);
    }

    public entry fun stock_bow(_: &mut ShopAdmin, shop: &mut Shop, ctx: &mut TxContext) {
        let bow = weapon::create_bow(ctx);
        vector::push_back(&mut shop.bows, bow);
    }

    // user functions

    public fun buy_axe(shop: &mut Shop, ctx: &mut TxContext): Invoice {
        // assertions check if axes are available
        let axe = vector::pop_back(&mut shop.axes);
        transfer::transfer(axe, tx_context::sender(ctx));
        Invoice{
            value: AXE_PRICE
        }
    }

    public fun pay_invoice(shop: &mut Shop, invoice: Invoice, gold: Coin<GOLD>) {
        let Invoice {value} = invoice;
        assert!(value == coin::value(&gold), EGoldNotExact);
        let balance = coin::into_balance(gold);
        balance::join(&mut shop.balance, balance);
    }

    public fun trade_in_axe(shop: &mut Shop, axe: Weapon<Axe>): Invoice {
        let invoice = Invoice {
            value: AXE_PRICE / 2
        };
        vector::push_back(&mut shop.axes, axe);
        invoice
    }

    public entry fun buy_axe_in_full (shop: &mut Shop, gold: Coin<GOLD>, ctx: &mut TxContext) {
        let invoice = buy_axe(shop, ctx);
        pay_invoice(shop, invoice, gold);
    }
}
