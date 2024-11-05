import sys
from pathlib import Path

file_name: str = sys.argv[0]

file: Path = Path(file_name) 

if file.exists():
  with open(file) as f:
     lines: list[str] = f.readlines()
     for line in lines:
      print(line)
else:
  print("No file Found!")