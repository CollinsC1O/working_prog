#[starknet::interface]
trait IBalancer<TContractState> {
    fn increase_balance(ref self: TContractState, amount: felt252);
    fn get_balance(self: @TContractState) -> felt252;
}

mod BalanceContract {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[abi(embed_v0)]
    impl BalanceImpl of super::IBalancer<TContractState> {
        fn increase_balance(ref self: TContractState, amount: felt252) {
            assert(amount != 0, 'Invalid amount');
            self.balance.write(self.balance.read() + amount);
        }
        fn get_balance(self: @TContractState) -> felt252 {
            self.balance.read()
        }
    }
}


#[cfg(test)]
mod test {
    use starknet::ContractAddress;
    use super::IBalancer;
    use super::BalanceContract;
    use snforge_std::{declear, ContractClassTrait};
    use array::ArrayTrait;

    mod Error {
        const ZERO_ERROR: felt252 = 'Incorrect Balance';
    }

    const AMOUNT_INCREASE: felt252 = 100;

    fn contract_deploy() -> ContractAddress {
        let contract = declear(BalanceContract);
        let contract_address = contract.deploy(@ArrayTrait.new()).unwrap();
        contract_address
    }

    #[test]
    fn test_increase_balance() {
        let contract_address = contract_deploy;
        let dispatcher = IBalancerDispatcher(contract_address);
        dispatcher.increase_balance(AMOUNT_INCREASE);
        let balance = dispatcher.get_balance();
        assert(balance == AMOUNT_INCREASE, Error::ZERO_ERROR)
    }
}
