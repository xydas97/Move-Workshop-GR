#[test_only]
module nftrpg::test_weapon {
    use sui::test_scenario;
    use sui::transfer;

    use nftrpg::weapon::{Self, Weapon, Axe};


    const EWrongAxeDmg: u64 = 0;
    // fun init -- If it is needed
    #[test]
    // #[expected_failure(abort_code = 1)]
    fun create_axe() {
        // initialize variables
        let admin = @0xCAFE;
        let player = @0xFACE;

        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        /*
        {
            init(admin);
        };
        */

        test_scenario::next_tx(scenario, admin);
        {
            let ctx = test_scenario::ctx(scenario);
            let axe =  weapon::create_axe(ctx);

            assert!(weapon::dmg(&axe) == 256, EWrongAxeDmg);
            transfer::transfer(axe, player);

        };

        test_scenario::next_tx(scenario, player);
        {
            
            let axe = test_scenario::take_from_sender<Weapon<Axe>>(scenario);
            assert!(weapon::dmg(&axe) == 256, EWrongAxeDmg);
            test_scenario::return_to_sender(scenario, axe);
        };
        
        test_scenario::end(scenario_val);

    }
}