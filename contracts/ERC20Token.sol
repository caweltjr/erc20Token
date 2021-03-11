// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.6;

interface ERC20Interface {
    function transfer(address to, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function approve(address spender, uint tokens) external returns (bool success);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function totalSupply() external view returns (uint);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
contract ERC20Token is ERC20Interface{
    // optional variables
    string public name;
    string public symbol;
    uint8 public decimals;
    // required variables
    uint public totalSupply;
    mapping(address => uint) public balances; //uint is the balance for an address
    // first address is token holder; second address is the third party approved to transferFrom; uint is
    // the maximum # of tokens that this third party can transfer on behalf of the token holder
    mapping(address => mapping(address => uint)) public allowed;

    constructor(string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint _totalSupply) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;// give all the tokens to the guy that creates this contract
    }
    function transfer(address to, uint value) public returns(bool){
        require(balances[msg.sender] >= value, 'token balance too low');
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
    function transferFrom(address from, address to, uint value) public returns(bool){
        uint allowance = allowed[from][msg.sender];
        // is this allowed? msg.sender is sending HIS tokens ON BEHALF OF from; not sending FROMs tokens
        require(balances[msg.sender] >= value && allowance >= value, 'not enough tokens in your allowance to transfer');
        //decrease the allowed from msg.sender
        allowed[from][msg.sender] -= value;
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    }
    function approve(address spender, uint value) public returns (bool){
        require(spender != msg.sender,'cannot approve of yourself');
        allowed[msg.sender][spender] = value; // increase the allowance
        emit Approval(msg.sender, spender, value);
        return true;
    }
    function allowance(address owner, address spender) public view returns (uint){
        return allowed[owner][spender];
    }
}

