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

## Step by Step (via Sui Client)
###Prerequisites

### Publishing the module
The first step, after succesfully building the project, is to publish it on Sui Blockchain giving a sufficient gas budget:
$sui client publish --gas-budget 10000

## Pattern Explanation (through demo)
### <a name="capabilitites"></a> Capabilitites

### <a name="mtypes"></a> Marker Types

### <a name="otw"></a> One-time witness

### <a name="hpotato"></a> Hot Potato
