// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; 

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see. 
 * You can update your password at any time.
 */


contract PasswordStore {
    error PasswordStore__NotOwner();

    // next section is State variables and it is storage variable owner and password  and it is private  

    address private s_owner;


    //@audit  the s_password variable is not  actually  private !   this is not a safe  place  to secure  your password !!!!!

    // private data on onchain is not actually private,all information on a blockchain  is public information   so just beacuse thhis S_password is private doest not mean its actually private 

   string private s_password;

    // next is events

    event SetNetPassword();

    constructor() {
        s_owner = msg.sender;
    }
 
    /*
     * @notice This function allows only the owner to set a new password.
     * @param newPassword The new password to set.
     */

    //q  can a non owner set the password?
    // q should a non owner be able to set a password?
    //@audit  any user can set a password
    // @audit missing access control

    function setPassword(string memory newPassword) external  {
        s_password = newPassword;
        emit SetNetPassword();
    }
 
    /*
     * @notice This allows only the owner to retrieve the password.
     * @param newPassword The new password to set.
     */

    //@audit their is no newpassword parameter
    function getPassword() external view returns (string memory) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return s_password;
    }
}
