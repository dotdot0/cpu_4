import sys
from pathlib import Path

file_name: str = sys.argv[1]
file: Path = Path(file_name)

if file.exists():
    with open(file, "r") as f:
        lines: list[str] = f.readlines()
        for line in lines:
            instr: list[str] = line.strip().split(" ")
            match instr[0]:
                case "NOP":
                    print("0000 0000")
                case "LOAD":
                    number: int = int(instr[1])
                    print(f"0001 {number:04b}")
                case "ADD":
                    print("0010 0000")
                case "AND":
                    print("0100 0000")
                case "SUB":
                    print("0011 0000")
                case "OR":
                    print("0101 0000")
                case "XNOR":
                    print("0111 0000")
                case "STORE":
                    const: int = int(instr[1])
                    print(f"0110 {const:04b}")
                case "JMP":
                    point: int = int(instr[1])
                    print(f"1000 {point:04b}")
                case _:
                    print("[ERROR] Invalid Instruction")
else:
    print("No File Found")
