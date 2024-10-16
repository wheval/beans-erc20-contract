#[starknet::interface]
pub trait IBeans<TContractState> {
    fn mint(ref self: TContractState, amount: u256);
}
