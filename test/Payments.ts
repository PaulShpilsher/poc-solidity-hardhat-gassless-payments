import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { arrayify} from "@ethersproject/bytes";

import type { Payments } from "../typechain-types";

describe("Payments", function () {
  async function deployPaymentsFixture() {
    const [owner, receiver] = await ethers.getSigners();

    const factory = await ethers.getContractFactory("Payments");
    const payments: Payments = await factory.deploy({
      value: ethers.parseEther("100.0"),
    });
    await payments.waitForDeployment();

    const paymentsAddress = await payments.getAddress();

    return { payments, paymentsAddress, owner, receiver };
  }

  it("Should send and receive funds", async function () {
    const { payments, paymentsAddress, owner, receiver } = await loadFixture(
      deployPaymentsFixture
    );

    const amount = ethers.parseEther("2.0");
    const nonce = 1;

    const hash = ethers.solidityPackedKeccak256(
      ["address", "uint256", "uint256", "address"],
      [receiver.address, amount, nonce, paymentsAddress]
    );

    // console.log("hhash -->", hash);

    // console.log(
    //   "chash -->",
    //   ethers.solidityPackedKeccak256(
    //     ["string", "bytes32"],
    //     ["\x19Ethereum Signed Message:\n32", hash]
    //   )
    // );

    const messageHashBinary = arrayify(hash);
    const signature = await owner.signMessage(messageHashBinary);
    console.log("signature -->", signature);

    const r = await payments.connect(receiver).claim(amount, nonce);
    console.log("rhash -->", r);
  });
});
