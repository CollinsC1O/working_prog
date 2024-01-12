
#[starknet::interface]
trait Ibalance<TContractState> {
    fn increace_balance(ref self: ContractState, amount: felt252);
    fn get_balance(self: ContractState) -> felt252;
}

#[starknet::contract]
mod BalanceContract {
    use statrknet::ContractAddress;
    
    #[storage]
    struct Storage {
        balance: felt252,
    }

    
}