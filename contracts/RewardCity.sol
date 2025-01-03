// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract RewardCity is IERC20, Ownable, Pausable, ReentrancyGuard {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _blacklist;

    uint256 private _totalSupply;
    address private _treasury;
    uint256 private _transactionFee = 10; // Taxa de transação (1% = 10/1000).

    constructor(address initialOwner, address initialTreasury) Ownable(initialOwner) {
        require(initialTreasury != address(0), "Invalid treasury address");
        _totalSupply = 100000 * 10 ** decimals();
        _balances[initialOwner] = _totalSupply;
        _treasury = initialTreasury;
    }

    function name() public pure returns (string memory) {
        return "RewardCity";
    }

    function symbol() public pure returns (string memory) {
        return "REWA";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        uint256 fee = (amount * _transactionFee) / 1000;
        uint256 amountAfterFee = amount - fee;

        require(!_blacklist[msg.sender], "Sender is blacklisted");
        require(!_blacklist[recipient], "Recipient is blacklisted");
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        require(recipient != address(0), "Invalid recipient address");

        _balances[msg.sender] -= amount;
        _balances[recipient] += amountAfterFee;
        _balances[_treasury] += fee;

        emit Transfer(msg.sender, recipient, amountAfterFee);
        emit Transfer(msg.sender, _treasury, fee);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        require(_allowances[sender][msg.sender] >= amount, "Insufficient allowance");
        require(_balances[sender] >= amount, "Insufficient balance");
        require(recipient != address(0), "Invalid recipient address");
        require(!_blacklist[sender], "Sender is blacklisted");
        require(!_blacklist[recipient], "Recipient is blacklisted");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        _allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    function burn(uint256 amount) public {
        require(_balances[msg.sender] >= amount, "Insufficient balance to burn");
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Invalid address");
        require(_totalSupply + amount > _totalSupply, "Overflow error");
        _totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function updateTreasury(address newTreasury) public onlyOwner {
        require(newTreasury != address(0), "Invalid address");
        _treasury = newTreasury;
    }

    function pauseTransfers() public onlyOwner {
        _pause();
    }

    function unpauseTransfers() public onlyOwner {
        _unpause();
    }

    function setTransactionFee(uint256 fee) public onlyOwner {
        require(fee <= 50, "Fee too high");
        _transactionFee = fee;
    }

    function blacklistAddress(address account, bool value) public onlyOwner {
        require(account != owner(), "Cannot modify owner blacklist status");
        _blacklist[account] = value;
    }

    function isBlacklisted(address account) public view returns (bool) {
        return _blacklist[account];
    }
}
