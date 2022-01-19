// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Notas {
    //Teacher address
    address public teacher;

    constructor() public {
        teacher = msg.sender;
    }

    //ID student with their notes
    mapping(bytes32 => uint256) Notas;

    string[] reviews;

    event student_evaluate(bytes32, uint256);
    event event_review(string);

    function evaluate(string memory _idStudent, uint256 _score)
        public
        onlyTeacher(msg.sender)
    {
        bytes32 hash_id = keccak256(abi.encodePacked(_idStudent));
        Notas[hash_id] = _score;
        emit student_evaluate(hash_id, _score);
    }

    modifier onlyTeacher(address _address) {
        require(_address == teacher, "You don't have access to this function");
        _;
    }

    function seeScores(string memory _idStudent) public view returns (uint256) {
        bytes32 hash_id = keccak256(abi.encodePacked(_idStudent));
        uint256 score_student = Notas[hash_id];
        return score_student;
    }

    function requireReview(string memory _idStudent) public {
        reviews.push(_idStudent);
        emit event_review(_idStudent);
    }

    function seeRequireReview()
        public
        view
        onlyTeacher(msg.sender)
        returns (string[] memory)
    {
        return reviews;
    }
}
