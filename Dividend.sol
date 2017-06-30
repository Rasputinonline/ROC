pragma solidity ^0.4.8;


import './ERC20.sol';

import './ICO.sol';

contract Dividend is ERC20
{
    ICO instance;
    // contract for sharing dividend on each token to requested token holders
    uint public totalSupply = 5000000;  // total supply of 6-- 0
      
      mapping(address => uint) balances;

      mapping(address => address) private userStructs;

      mapping (address => mapping (address => uint)) allowed;
      
      address owner;
      
      uint256 ether_profit;
      
      uint256 profit_per_token;
      
      uint256 holder_token_balance;
      
      uint256 holder_profit;
      
      event Message(uint256 holde_profit);

       address[] addresses;
      
      function Dividend(address ico_contract)
      {
          
          instance = ICO(ico_contract);
      }
    

    function () payable
    {
        //------accepting ether as profit
        
        ether_profit = msg.value;
        
        profit_per_token = (ether_profit)/(totalSupply);
        
        Message(ether_profit);
        
         Message(profit_per_token);
            
        if(addresses.length >0)
        {
             for (uint i = 0; i < addresses.length; i++) {

                 request_dividend(addresses[i]);

             }
        }

        
        
    }
    
    function request_dividend(address token_holder) payable
    {
        
        holder_token_balance = instance.balanceOf(token_holder);
        
        Message(holder_token_balance);
        
        holder_profit = holder_token_balance * profit_per_token;
        
        Message(holder_profit);
        
    
        token_holder.send(holder_profit);   
        
    }
      
    
     function balanceOf(address sender) constant returns (uint256 balance) {
      
          return instance.balanceOf(sender);
      }
      
       // Transfer the balance from owner's account to another account
      function transfer(address _to, uint256 _amount) returns (bool success) {
          if (balances[msg.sender] >= _amount 
              && _amount > 0
              && balances[_to] + _amount > balances[_to]) {
              balances[msg.sender] -= _amount;
              balances[_to] += _amount;
              Transfer(msg.sender, _to, _amount);

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
    
}