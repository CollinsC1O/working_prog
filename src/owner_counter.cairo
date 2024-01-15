//importing contract address
use starknet::ContractAddress;

//counter interface
#[starknet::interface]
trait ICounter<TContractState> {
    fn increase_counter(ref self: ContractState);
    fn get_counter(self: @ContractState) -> felt252;
}

//owner interface
#[starknet::interface]
trait IOwnable<TContractState> {
    fn set_owner(ref self: ContractState);
    fn get_owner(self: @ContractState) -> ContractAddress;
}

//the contract
#[starknet::contract]
mod counter_contract {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        counter: felt252,
        owner: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_counter: u32, initial_owner: ContractAddress) {
        self.counter.write(initial_counter);
        self.owner.write(initial_counter);
    }


    //implementation of the counter interface
    #[abi(embed_v0)]
    impl CounterImpl of super::ICounter<TContractState> {
        fn increase_counter(ref self: ContractState) {
            let current_counter = self.counter.read();
            self.counter.write(current_counter + 1);
        }

        fn get_counter(self: @ContractState) -> felt252 {
            self.counter.read()
        }
    }

    //implementation of the owner interface
    #[abi(embed_v0)]
    impl OwnableImpl of super::IOwnable<TContractState> {
        fn set_owner(ref self: ContractState, new_owner: ContractAddress) {
            assert(!new_owner.is_zero(), 'INVALID ADDRESS');
            self.owner.write(new_owner);

            assert_only_owner(@self)
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }

    #[generate_trait]
    impl internal of InternalTrait {
        fn assert_only_owner(self: @ContractState) {
            let owner: ContractAddress = self.owner.read();
            let caller = get_caller_address();

            assert(caller == owner, 'Caller not Owner')
        }
    }
}
