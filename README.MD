# Move Workshop GR
This repository includes the source code of the demo project that was developed to introduce features, (standard) libraries and programming patterns (listed below) in Sui Move, with the theme of an RPG that stores avatars, shops and weapons on-chain. 

It is structured according to Amnn's Move Workshop. You can find the orginal @: www.github.com/amnn/nftrpg

## Examples In this Demo

### Language Features
- Abilities (copy, drop, key, store)
- Asserts, aborts and error codes
- Constants
- Functions (entry functions, library functions and private functions)
- Generics (including phantom types)
- Module Initializers
- Objects (owned and shared)
- References
- Structs
- Vectors

### Patterns
- [Capabilities](#capabilitites)
- [One Time Witness](#otw)
- [Marker types](#mtypes)
- [Hot Potato](#hpotato)

### Standard Libraries
- `std::option` -- Options
- `std::string` -- Strings (built on top of vectors)
- `sui::coin`, `sui::balance` -- Generic Token API
- `sui::dynamic_object_field` -- Dynamic object fields
- `sui::transfer` -- Transferring and sharing

## Building, publishing, interacting with the modules (via Sui Client)
In order to build a Move package and run code defined in this package, first [install Sui](https://docs.sui.io/build/install) and [connect to Sui Devnet](https://docs.sui.io/build/devnet).

### Building the package
Follow the commands below to clone the repository and build the package:
```sh
  $ git clone https://github.com/xydas97/Move-Workshop-GR.git
  $ cd Move-Workshop-GR
  $ sui move build
```

### Publishing the package
At first, you have to ensure that you have devnet SUI coins under your active address so that you can pay for gas fees:
```sh
  $ sui client gas
```
If not, you can request from devnet-faucet in Discord server.
The next step, after succesfully building the project, is to publish it on Sui Blockchain giving a sufficient gas budget:
```sh
  $ sui client publish --gas-budget 10000
```
The immutable object that will be created will represent your package, so it is a good practice to save its id in a variable:
```sh
  $ package="<ID>"
```
Also save your active address in a variable for ease of function calling:
```sh
  $ sui client active-address
  $ address="<ID>"
```

### Creating your first Avatar
Examining the avatar module, you can find out that in order to create an avatar you need to pass some gold. To do that, we first have to mint and transfer some coins of type gold. The only one who has this capability is the address with TreasuryCap<GOLD> object which is created once during the package publishing and transfered to the publisher. To check your owned objects run this command:
```sh
  $ sui client objects
```
Locate the object with TreasuryCap type and save its id:
```sh
  $ cap="<ID>"
```
Next thing, create gold coins with the function mint_and_transfer which can be found in [sui package](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/sources/coin.move). The arguments will be the TreasuryCap object, amount of gold, recipient and the type argument will be the marker type of gold:
```sh
  $ sui client call --package 0x2 --module coin --function mint_and_transfer --args "$cap" 10000 "$address" --type-args "$package::gold::GOLD"  --gas-budget 10000
```
Save the gold id for usage in avatar creation:
```sh
  $ gold="<ID>"
```
Final step, decide your avatar's name and call the create function of avatar module with all the needed arguments:
```sh
  $ sui client call --package "$package" --module avatar --function create --args "Name" "$gold" "$address" --gas-budget 10000
```
Keep your avatar's id so that you can equip it with a weapon of your choice:
```sh
  $ avatar="<ID>"
```

### Equiping your avatar

After succesfully creating your first avatar, it is time to equip it with an appropriate weapon. The way to do, is to create it with the function get_weapon, choosing its type (0, 1, or 2) and send it to a recipient:
```sh
  $ sui client call --package "$package" --module weapon --function get_weapon --args "2" "$address" --gas-budget 10000
```
In this case a bow is created and sent to your address:
```sh
  $ bow="<ID>"
```
Last step, add the weapon you just created to your avatar by calling the function wield and giving the appropriate type argument:
```sh
  $ sui client call --package "$package" --module avatar --function wield --args "$avatar" "$bow" --type-args "$package::weapon::Bow" --gas-budget 10000
```
You can now check all your owned objects on [Sui explorer](https://explorer.sui.io/) by entering your active address.

## Pattern Explanation (through demo)

### <a name="capabilitites"></a> Capabilitites
Capability is a pattern that allows authorizing actions with an object. One of the most common capabilities is TreasuryCap (defined in sui::coin). In the gold module you can find an example of this pattern. Once the module is initialized, a TreasuryCap of type GOLD is created and transfered to the sender. This ensures that only the owner of this capability object can mint coins of type GOLD. Also, you can see the same example in shop module where we define a ShopAdmin struct. Once the module is initialized, the ShopAdmin capability is transfered to the publisher and is now the only one who can call entry functions that require this capability (eg. stock_axe).   

### <a name="otw"></a> One Time Witness
One Time Witness (OTW) is a special instance of a type which is created only in the module initializer and is guaranteed to be unique and have only one instance. It is important for cases where we need to make sure that a witness-authorized action was performed only once (for example - creating a new Coin). For a type to be considered as one time witness should have only the drop ability and be named after the module but uppercased. This is the case in gold module, where a GOLD struct is defined to be one time witness and a full instance of it is passed as the first argument in the init function. 

### <a name="mtypes"></a> Marker Types
Marker type is a struct that has no abilities and no fields. It is used to distinguish between different types of a certain object. Weapon module uses this kind of pattern. A weapon struct is defined with a phantom T generic type along with three marker types, Axe, Sword and Bow. Each time a weapon is created, one of these marker types should be passed as type argument in order to distinguish the kind of weapon that is instantiated.

### <a name="hpotato"></a> Hot Potato
Hot Potato is a name for a struct that has no abilities, hence it can only be packed and unpacked in its module. In this struct, you must call function B after function A in the case where function A returns a potato and function B consumes it. In this project, a hot potato appears in the shop module. Invoice struct has no abilities and only one field. It is created and returned from function buy_axe (function A) and then it is passed in function pay_invoice (function B) to consume it. With this pattern you ensure that buy_axe_in_full entry function will work only if invoice get paid (consumed) in pay_invoice function. Also, it offers some extra functionalities, as invoice can be passed in another function before consumed and modify its value.
