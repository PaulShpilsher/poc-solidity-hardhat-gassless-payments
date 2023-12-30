// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

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
        uint256 nonce,
        bytes memory signature
    ) external {
        require(
            !nonces[nonce],
            "You can't claim twice with the same nonce"
        );
        nonces[nonce] = true;

        bytes32 message = MessageHashUtils.toEthSignedMessageHash( // keccak256("\x19Ethereum Signed Message:\n32", hash)
            keccak256(
                abi.encodePacked(msg.sender, amount, nonce, address(this))
            )
        );

        // require(
        //     recoverSigner(message, signature) == owner,
        //     "Invalid signature"
        // );

        require(ECDSA.recover(message, signature) == owner, "Invalid signature");

        payable(msg.sender).transfer(amount);
    }

    // function recoverSigner(
    //     bytes32 message,
    //     bytes memory signature
    // ) private pure returns (address) {
    //     (uint8 v, bytes32 r, bytes32 s) = splitSignature(signature);
    //     return ecrecover(message, v, r, s);
    // }

    // function splitSignature(
    //     bytes memory sig
    // ) private pure returns (uint8 v, bytes32 r, bytes32 s) {
    //     require(sig.length == 65, "Invalid signature length");

    //     assembly {
    //         // first 32 bytes, after the length prefix
    //         r := mload(add(sig, 32))
    //         // second 32 bytes
    //         s := mload(add(sig, 64))
    //         // final byte (first byte of the next 32 bytes)
    //         v := byte(0, mload(add(sig, 96)))
    //     }
    // }

    // function withPrefix(bytes32 hash) private pure returns (bytes32) {
    //     return
    //         keccak256(
    //             abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
    //         );
    // }
}
