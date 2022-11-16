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
- [Marker types](#mtypes)
- [One-time witness](#otw)
- [Hot Potato](#hpotato)

### Standard Libraries
- `std::option` -- Options
- `std::string` -- Strings (built on top of vectors)
- `sui::coin`, `sui::balance` -- Generic Token API
- `sui::dynamic_field` -- Dynamic fields 
- `sui::dynamic_object_field` -- Dynamic object fields
- `sui::transfer` -- Transferring and sharing

## Building, publishing, interacting with the modules (via Sui Client)
In order to build a Move package and run code defined in this package, first [install Sui](https://docs.sui.io/build/install) and [connect to Sui Devnet](https://docs.sui.io/build/devnet).

### Building the package
Follow the commands below to clone the repository and build the package:
```sh
  $ git clone https://github.com/xydas97/Move-Workshop-GR.git
  $ cd nftrpg
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

## Pattern Explanation (through demo)

### <a name="capabilitites"></a> Capabilitites

### <a name="mtypes"></a> Marker Types

### <a name="otw"></a> One-time witness

### <a name="hpotato"></a> Hot Potato
