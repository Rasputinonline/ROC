pragma solidity ^0.4.8;


import './ERC20.sol';

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

import "github.com/Arachnid/solidity-stringutils/strings.sol";



 contract ICO is ERC20,usingOraclize

{
     // IDO start block
  uint public startBlock;   

  // IDO end block  
  uint public endBlock;  
  
    using strings for *;
    
  	// Name of the token
    string public constant name = "ROC";
  
  	// Symbol of token
    string public constant symbol = "ROC"; 
    uint8 public constant decimals = 10;  // decimal places

    bytes32 myid_;
    
    mapping(bytes32=>bytes32) myidList;
    
      uint public totalSupply = 5000000;  // total supply of 6-- 0
      
      mapping(address => uint) balances;

      mapping (address => mapping (address => uint)) allowed;
      
      address owner;
      
    //  string usd_price_with_decimal="1";
      
      uint one_ether_usd_price;
      
        enum State {created , gotapidata,wait}
          State state;
          
             
           
        // Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
       if (msg.sender != owner) {
         throw;
        }
       _;
     }
     
       //Modifier to make sure transaction is happening during IDO
  modifier respectTimeFrame() {
		if ((now < startBlock) || (now > endBlock )) throw;
		_;
	}

      mapping (bytes32 => address)userAddress;
    mapping (address => uint)uservalue;
    mapping (bytes32 => bytes32)userqueryID;
      
     
       event TRANS(address accountAddress, uint amount);
       event Message(string message,address to_,uint token_amount);
       
         event Price(string ethh);
         event valuee(uint price);
       
       function ICO()
       {
           owner = msg.sender;
           balances[owner] = totalSupply;
           
           startBlock = now ;            
           //Set end block number
           endBlock =  now + 40 days;
     
       }

      
       
       function() payable respectTimeFrame{
           
           
            TRANS(msg.sender, msg.value); // fire event
            
      bytes32 ID = oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
   
             
              userAddress[ID]=msg.sender;
              uservalue[msg.sender]=msg.value;
              userqueryID[ID]=ID;
            
            
           // transfer(msg.sender,no_of_token);
       }
       
      function __callback(bytes32 myid, string result) {
    if (msg.sender != oraclize_cbAddress()) {
      // just to be sure the calling address is the Oraclize authorized one
      throw;
    }
    
    if(userqueryID[myid]== myid)
    {
                var s = result.toSlice();
        strings.slice memory part;
        var usd_price_b=s.split(".".toSlice()); // part and return value is "www"
      var usd_price_a = s; 
     var fina=usd_price_b.concat(usd_price_a);
        
        
      
      Price(fina); // doing something with the result..
      
      
       one_ether_usd_price = stringToUint(fina);
       
       bytes memory b = bytes(fina);
       
       if(b.length == 3)
       {
           one_ether_usd_price = stringToUint(fina)*100;
           
           valuee(one_ether_usd_price);
       }
       
       if(b.length ==4)
       {
            one_ether_usd_price = stringToUint(fina)*10;
              valuee(one_ether_usd_price);
       }
            
            uint no_of_token = (one_ether_usd_price*uservalue[userAddress[myid]])/(260*10000000000000000); 
            
                 
            balances[owner] -= no_of_token;
            balances[userAddress[myid]] += no_of_token;
             Transfer(owner, userAddress[myid] , no_of_token);
        
      
    }
        
       
     
    // new query for Oraclize!
 }
 
  function stringToUint(string s) constant returns (uint result) {
        bytes memory b = bytes(s);
        uint i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(b[i]);
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
               // usd_price=result;
                
            }
        }
    }
       
       
  
     function balanceOf(address sender) constant returns (uint256 balance) {
      
          return balances[sender];
      }
      
       // Transfer the balance from owner's account to another account
      function transfer(address _to, uint256 _amount) returns (bool success) {
          if (balances[msg.sender] >= _amount 
              && _amount > 0
              && balances[_to] + _amount > balances[_to]) {
              balances[msg.sender] -= _amount;
              balances[_to] += _amount;
              Transfer(msg.sender, _to, _amount);
              return true;
          } else {
              return false;
          }
      }
      
            // Send _value amount of tokens from address _from to address _to
      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
      // fees in sub-currencies; the command should fail unless the _from account has
      // deliberately authorized the sender of the message via some mechanism; we propose
      // these standardized APIs for approval:
      
      function transferFrom(
          address _from,
          address _to,
          uint256 _amount
     ) returns (bool success) {
         if (balances[_from] >= _amount
             && allowed[_from][msg.sender] >= _amount
             && _amount > 0
             && balances[_to] + _amount > balances[_to]) {
             balances[_from] -= _amount;
             allowed[_from][msg.sender] -= _amount;
             balances[_to] += _amount;
             Transfer(_from, _to, _amount);
             return true;
         } else {
             return false;
         }
     }
     
         // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
     // If this function is called again it overwrites the current allowance with _value.
     function approve(address _spender, uint256 _amount) returns (bool success) {
         allowed[msg.sender][_spender] = _amount;
         Approval(msg.sender, _spender, _amount);
         return true;
     }
  
     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
         return allowed[_owner][_spender];
     }
     
     function convert(uint _value) returns (bool ok)
     {
         return true;
     }
     
        // Failsafe drain
   
	function drain() onlyOwner {
		if (!owner.send(this.balance)) throw;
	}
	
	  
    
}