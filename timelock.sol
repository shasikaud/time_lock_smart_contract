pragma solidity ^0.5.0;


contract Timelock {

    // beneficiary of the tokens -> after release time has passed, tokens will be transferred to this address
    address payable public beneficiary;

    //owner of this contract
    address public owner;

    // timestamp when tokens will be released
    uint256 public releaseTime;

    uint256 public lockedAmount;

    //access modifier to make certain functions only accessible by the contract owner
    modifier onlyOwner(){
      require(msg.sender == owner);
      _;
    }
    
    // accept incoming ERC20
    function () external payable {}

    constructor (address payable _beneficiary, uint256 _releaseTime) public {
        require(_releaseTime > block.timestamp, "release time is before current time");
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
        owner = msg.sender;

    }

    // transfers ERC20 held by timelock to the beneficiary
    function release() public onlyOwner {    
        require(block.timestamp >= releaseTime, "current time is before release time");

        uint256 amount = address(this).balance;
        require(amount > 0, "no ERC20 to be released");

        beneficiary.transfer(amount);
    }

    function view_locked_balance() public returns (uint256) {  
        lockedAmount = address(this).balance;
        return lockedAmount;
    }




}