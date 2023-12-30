// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

// Owner deposits some ether
// Owner notifies someone to receive the ether
// Someone claims the ether
contract Payments {
    address public owner;
    mapping(uint256 => bool) private nonces;

    constructor() payable {
        require(msg.value > 0, "You must send some ether");
        owner = msg.sender;
    }

    function claim(
        uint256 amount,
        uint256 nonce // ,
    )
        external
        view
        returns (
            // bytes memory signature
            bytes32
        )
    {
        // require(
        //     nonces[nonce] == false,
        //     "You can't claim twice with the same nonce"
        // );
        // nonces[nonce] == true;

        bytes32 message = MessageHashUtils.toEthSignedMessageHash( // keccak256("\x19Ethereum Signed Message:\n32", hash)
            keccak256(
                abi.encodePacked(msg.sender, amount, nonce, address(this))
            )
        );
        // bytes32 message = withPrefix(
        //     keccak256(
        //         abi.encodePacked(msg.sender, amount, nonce, address(this))
        //     )
        // );

        return message;
    }

    // function withPrefix(bytes32 hash) private pure returns (bytes32) {
    //     return
    //         keccak256(
    //             abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
    //         );
    // }
}
