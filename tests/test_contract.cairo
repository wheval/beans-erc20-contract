use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};


fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

