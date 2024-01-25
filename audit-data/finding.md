### [H-1] Variables stored in storage on-chain are visable to anyone , no matter  the solidity  visibility keyword  meaning  the password  is not  actually  a  privtae password 

**Description:** All data stored  on chain  is visible to anyone, and can be read directly from the blockchain. The 'passwordstore::S_password' variable  is  intended to be  a  private  variable  and only  accessed through  'passwordstore::getPassword' function , which is intended to be only called by owner of the contract.

we show one such method of reading any data off cahin below.

**Impact:**  Any one can read the private password. serverly breaking the function of the protocol.

**Proof of Concept:**(proof of code )

The below test case shows how anyone can read the password directly from the blockchain. 

1. Creat a locally running chain
'''bash
make anvil
'''

2. Deploy the contract to the chain 
'''
make deploy
'''

3. Run   the storgae tool 
we use'1' because that is the storage od 's_password' in the contract.

'''
cast storage <ADDRESS_HERE> 1 --rpc-url http://127.0.0.1:8545
'''

you will get an output that looks like this
'0x6d79515fvjfgbf000000000000000000000000014'

you can then parse that hex to a string with:

'''
cast parse-bytes32-string 0x6d79515fvjfgbf000000000000000000000000014
'''

And get an output of:

'''
mypassword
'''

**Recommended Mitigation:** due to this , th overall architecture of the contract should be rethougt. one could encrypt the password the offchain ,and then store the encrypted password on chain .. This would require the user to remember another password off chain to decrypt the password. however you had also likely want to remove the view function as you wouldn't want the user to accidentally send a transaction with the password that decrypt your password ...  



### [H-2] 'passwordStore::setpassword' has no acccess control, meaning a non-ownercould change the paaword


**Description:** 'passwordStore::setpassword' function is set  to be an 'external' function,however the natspec of the function and overall purpose of the smart contract is that 'This function allows only the owner to set a new password.' 

'''javascript
 function setPassword(string memory newPassword) external  {
@>   //@audit-There are no access controls
        s_password = newPassword;
        emit SetNetPassword();
    }
'''    

**Impact:** Anyone can set/change the password of the  contract, severly breaking  the contract intended  functionality.

**Proof of Concept:** Add the following  to the 'passwordStore.t.sol' test file

<details>
<summary>Code</summary>

'''javascript
    functiont test_anyone_can_set_password(address randomAddress) public{
    vm.assume(randomAddress != owner);
    vm.prank(randomAddress);
    string memory expectedpassword = "myNewPassword"
    passwordStore.setPassword(expectedpassword);

    vm.prank(owner);
    string memory actyalPassword =passwordStore.getPassword();
    assertEq(actualpassword,expectedPassword);
}
'''

</details>

**Recommended Mitigation:**  add an access control conditional to the 'setPassword' function.

'''javascript
if(msg.sender!= s_owner){
    revert passwordStore_NotOwner();
}
'''



### [I-1] The 'passwordStore::getPassword' natspec indicates a parameter that does not exist,causing the natspec to be incorrect

**Description:** 

'''javascript
   /*
    *@notice This allows only the owner to retrieve the password.
@>  * @param newpassword The new password to set.
    */
    function getPassword() external view returns (string memory) {
'''

The 'passwordStore::getPassword' function signature is 'getpassword()' while the natspec says it should be 'getpassword(string)'.



**Impact:** The natspec is incorrect.


**Recommended Mitigation:** REmove  the incorrect  natspec line .

'''diff
-     * @param newPassword The new password to set.
'''