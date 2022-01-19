// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Vote {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    mapping(string => bytes32) idCandidate;
    mapping(string => uint256) votesCandidate;
    string[] candidates;
    bytes32[] voters;

    function represent(
        string memory _name,
        uint256 age,
        string memory _id
    ) public {
        bytes32 hashCandidate = keccak256(abi.encode(_name, age, _id));
        idCandidate[_name] = hashCandidate;
        candidates.push(_name);
    }

    function getCandidates() public view returns (string[] memory) {
        return candidates;
    }

    function voteCandidate(string memory _candidate) public {
        bytes32 voterId = keccak256(abi.encode(msg.sender));
        for (uint256 i = 0; i < voters.length; i++) {
            require(voters[i] != voterId, "You had already voted");
        }
        voters.push(voterId);
        votesCandidate[_candidate] += 1;
    }

    function seeVotes(string memory _candidate) public view returns (uint256) {
        return votesCandidate[_candidate];
    }

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function seeResult() public view returns (string memory) {
        string memory results;
        for (uint256 i = 0; i < candidates.length; i++) {
            results = string(
                abi.encodePacked(
                    results,
                    "(",
                    candidates[i],
                    ",",
                    uint2str(seeVotes(candidates[i])),
                    ")"
                )
            );
        }
        return results;
    }

    function getWinner() public view returns (string memory) {
        string memory winner = candidates[0];
        bool flag;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (votesCandidate[winner] < votesCandidate[candidates[i]]) {
                winner = candidates[i];
                flag = false;
            } else {
                if (votesCandidate[winner] == votesCandidate[candidates[i]]) {
                    flag = true;
                }
            }
        }

        if (flag == true) {
            winner = "Tie between the candidates";
        }

        return winner;
    }
}
