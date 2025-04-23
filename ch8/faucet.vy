# @version ^0.3.10

event Deposit:
    sender: indexed(address)
    amount: uint256

event Withdrawal:
    receiver: indexed(address)
    amount: uint256

event LimitChanged:
    new_limit: uint256

owner: public(address)
withdraw_limit: public(uint256)
balances: public(HashMap[address, uint256])

@payable
@external
def __default__():
    self.balances[msg.sender] += msg.value
    log Deposit(msg.sender, msg.value)

@internal
def _log_withdraw(_to: address, _amount: uint256):
    log Withdrawal(_to, _amount)

@external
def __init__():
    self.owner = msg.sender
    self.withdraw_limit = as_wei_value(0.1, "ether")

@payable
@external
def deposit():
    assert msg.value > 0, "Must send ETH"
    self.balances[msg.sender] += msg.value
    log Deposit(msg.sender, msg.value)

@external
def withdraw(_amount: uint256):
    assert _amount <= self.withdraw_limit, "Exceeds withdraw limit"
    assert self.balances[msg.sender] >= _amount, "Insufficient balance"
    self.balances[msg.sender] -= _amount
    send(msg.sender, _amount)
    self._log_withdraw(msg.sender, _amount)

@external
def set_withdraw_limit(_new_limit: uint256):
    assert msg.sender == self.owner, "Only owner"
    self.withdraw_limit = _new_limit
    log LimitChanged(_new_limit)

@view
@external
def get_my_balance() -> uint256:
    return self.balances[msg.sender]
