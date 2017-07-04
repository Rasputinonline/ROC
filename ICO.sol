pragma solidity ^0.4.8;



import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";


contract ERC20 {

  uint public totalSupply;

  function balanceOf(address who) constant returns (uint256);

  function allowance(address owner, address spender) constant returns (uint);

  function transferFrom(address from, address to, uint value) returns (bool ok);

  function approve(address spender, uint value) returns (bool ok);

  function transfer(address to, uint value) returns (bool ok);

  function convert(uint _value) returns (bool ok);

  event Transfer(address indexed from, address indexed to, uint value);

  event Approval(address indexed owner, address indexed spender, uint value);

}

 contract ICO is ERC20,usingOraclize

{
     // IDO start block
  uint public startBlock;   

  // IDO end block  
  uint public endBlock;  

 address[] public addresses ;  

  	// Name of the token
    string public constant name = "ROC";
  
  	// Symbol of token
    string public constant symbol = "ROC"; 
    uint8 public constant decimals = 18;  // decimal places
    
      mapping(address => address) public userStructs;


    bytes32 myid_;
    
    mapping(bytes32=>bytes32) myidList;
    
      uint public totalSupply = 5000000 ;  
      
       mapping(address => uint) balances;

      mapping (address => mapping (address => uint)) allowed;
      
      address owner;
      
      
      uint one_ether_usd_price;
      
        enum State {created , gotapidata,wait}
          State state;
          
          uint256 ether_profit;
      
      uint256 profit_per_token;
      
      uint256 holder_token_balance;
      
      uint256 holder_profit;
      
       event Message(uint256 holder_profit);

      
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
          
       }

       function start_timeframe()
       {
            startBlock = now ;            
           //Set end block number
           endBlock =  now + 55 days;
       }

      
       
       function() payable {
           
           
            TRANS(msg.sender, msg.value); // fire event
            
            if(msg.sender != owner)
            {
            
      bytes32 ID = oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
   
             
              userAddress[ID]=msg.sender;
              uservalue[msg.sender]=msg.value;
              userqueryID[ID]=ID;
            }
            
            else if(msg.sender ==owner){
                
                  ether_profit = msg.value;
        
        profit_per_token = (ether_profit)/(totalSupply);
        
        Message(ether_profit);
        
         Message(profit_per_token);
            
        if(addresses.length >0)
        {
             for (uint i = 0; i < addresses.length; i++) {

                if(addresses[i] !=owner)
                {
                 request_dividend(addresses[i]);
                }

               }
                }
                
            }
            
            
           // transfer(msg.sender,no_of_token);
       }
       
      function __callback(bytes32 myid, string result) {
    if (msg.sender != oraclize_cbAddress()) {
      // just to be sure the calling address is the Oraclize authorized one
      throw;
    }
    
    if(userqueryID[myid]== myid)
    {

      
       one_ether_usd_price = stringToUint(result);
    
    valuee(one_ether_usd_price);
    
    if(one_ether_usd_price<1000)
    {
        one_ether_usd_price = one_ether_usd_price*100;
    }
    else if(one_ether_usd_price<10000)
    {
        one_ether_usd_price = one_ether_usd_price*10;
    }
    
    valuee(one_ether_usd_price);
            
            uint no_of_token = (one_ether_usd_price*uservalue[userAddress[myid]])/(275*10000000000000000*100); 
            
                 
            balances[owner] -= no_of_token;
            balances[userAddress[myid]] += no_of_token;
             Transfer(owner, userAddress[myid] , no_of_token);
             
              check_array_add(userAddress[myid]);
             
  
    }
        

 }
 
      function request_dividend(address token_holder) payable
    {
        
        holder_token_balance = balanceOf(token_holder);
        
        Message(holder_token_balance);
        
        holder_profit = holder_token_balance * profit_per_token;
        
        Message(holder_profit);
        
         Transfer(owner, token_holder , holder_profit);
        
    
        token_holder.send(holder_profit);   
        
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
              
             check_array_add(_to);
              
              return true;
          } else {
              return false;
          }
      }
      
      function check_array_add(address _to)
      {
            if(addresses.length >0)
              {
                 if(userStructs[_to] != _to)
              {
                   userStructs[_to]= _to;
                    addresses.push(_to);
              }
              }
              else
              {
                   userStructs[_to]= _to;
                   addresses.push(_to);
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
	
	  //Below function will convert string to integer removing decimal
	  function stringToUint(string s) returns (uint) {
        bytes memory b = bytes(s);
        uint i;
        uint result1 = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(b[i]);
            if(c == 46)
            {
                // Do nothing --this will skip the decimal
            }
          else if (c >= 48 && c <= 57) {
                result1 = result1 * 10 + (c - 48);
              // usd_price=result;
                
            }
        }
        return result1;
    }
    
      function transfer_ownership(address to) onlyOwner {
        //if it's not the admin or the owner
        if (msg.sender != owner) throw;
        owner = to;
         balances[owner]=balances[msg.sender];
         balances[msg.sender]=0;
    }

    
}