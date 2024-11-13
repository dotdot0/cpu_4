import sys
from pathlib import Path

# Input and output file paths
input_file_name: str = sys.argv[1]
output_file_name: str = "program.bin"

input_file: Path = Path(input_file_name)

if input_file.exists():
    with open(input_file, "r") as f, open(output_file_name, "w") as out_file:
        lines: list[str] = f.readlines()
        for line in lines:
            instr: list[str] = line.strip().split(" ")
            match instr[0]:
                case "NOP":
                    out_file.write("0000 0000\n")
                case "LOAD":
                    number: int = int(instr[1], 2)  # Parse as binary directly
                    out_file.write(f"0001 {number:04b}\n")
                case "ADD":
                    out_file.write("0010 0000\n")
                case "AND":
                    out_file.write("0100 0000\n")
                case "SUB":
                    out_file.write("0011 0000\n")
                case "OR":
                    out_file.write("0101 0000\n")
                case "XNOR":
                    out_file.write("0111 0000\n")
                case "SLEEP":
                    out_file.write(f"1000 0000\n")
                case _:
                    print("[ERROR] Invalid Instruction")
else:
    print("No File Found")
