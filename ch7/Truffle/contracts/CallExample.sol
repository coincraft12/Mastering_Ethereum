// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CalledContract {
    event CallEvent(address sender, address origin, address current);

    function calledFunction() public {
        emit CallEvent(msg.sender, tx.origin, address(this));
    }
}

library CalledLibrary {
    event CallEvent(address sender, address origin, address current);

    function calledFunction() public {
        emit CallEvent(msg.sender, tx.origin, address(this));
    }
}

contract Caller {
    function makeCalls(address _calledContractAddress) public {
        // 인터페이스로 캐스팅
        CalledContract called = CalledContract(_calledContractAddress);

        // 1. 일반 함수 호출
        called.calledFunction();

        // 2. 라이브러리 함수 호출 (단독 호출 시 제한 있음 — 예시 용도)
        CalledLibrary.calledFunction();

        // 3. Low-level call
        (bool success1, ) = _calledContractAddress.call(
            abi.encodeWithSignature("calledFunction()")
        );
        require(success1, "call failed");

        // 4. delegatecall
        (bool success2, ) = _calledContractAddress.delegatecall(
            abi.encodeWithSignature("calledFunction()")
        );
        require(success2, "delegatecall failed");
    }
}
