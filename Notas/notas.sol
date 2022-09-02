// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0;
pragma experimental ABIEncoderV2;

contract notas {
    address public profesor;

    // Se asigna el rol de profesor a quien despliega el contrato.
    constructor() {
        profesor = msg.sender;
    }

    // Se relaciona el hash de la identidad del alumno con su nota.
    mapping(bytes32 => uint) Notas;

    string[] revisiones;

    // Eventos.
    event alumno_evaluado(bytes32);
    event evento_revision(string);

    modifier OnlyTeacher(address _direccion) {
        require(_direccion == profesor, "No eres el profesor.");
        _;
    }
    // Evaluar alumnos.
    function evaluar(string memory _idAlumno, uint _nota) public OnlyTeacher(msg.sender) {
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        Notas[hash_idAlumno] = _nota;
        emit alumno_evaluado(hash_idAlumno);
    }

    function verNotas(string memory _idAlumno) public view returns(uint) {
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        uint nota_alumno = Notas[hash_idAlumno];
        return  nota_alumno;
    }
    
    function revision(string memory _idAlumno) public {
        revisiones.push(_idAlumno);
        emit evento_revision(_idAlumno);
    }

    function verRevision() public view OnlyTeacher(msg.sender) returns(string[] memory){
        return revisiones;
    }
}