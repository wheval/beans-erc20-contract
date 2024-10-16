#[starknet::contract]
pub mod Beans {
    use OwnableComponent::InternalTrait;
use core::starknet::get_caller_address;
    use core::starknet::ContractAddress;
    use core::num::traits::Zero;
    use beans::interface::beans::IBeans;
    use openzeppelin::token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin::access::ownable::OwnableComponent;

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl ERC20MixinImpl = ERC20Component::ERC20MixinImpl<ContractState>;

    #[abi(embed_v0)]
    impl OwnableCamelOnlyImpl = OwnableComponent::OwnableCamelOnlyImpl<ContractState>;

    //internal implenentation
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;
    
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;


    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event,
        OwnableEvent: OwnableComponent::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        let name = "Beans";
        let symbol = "BNS";
        self.erc20.initializer(name, symbol);
        self.ownable.initializer(owner);
    }

    #[abi(embed_v0)]
    impl BeansImpl of IBeans<ContractState> {
        fn mint(ref self: ContractState, amount: u256) {
            self.ownable.assert_only_owner();
            let caller = get_caller_address();
            assert(caller.is_non_zero(), 'Zero caller address');
            self.erc20.mint(caller, amount);
        }
    }
}
