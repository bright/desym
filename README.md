# desym
Small bash utility that makes it a bit easier to desymbolicate crash logs from command line.

## How to use it 

1. Create an empty folder
2. Put .ipa file in it
3. Put .dsym.zip file in it
4. Put desym.sh file in it
5. Execute ```./desym.sh MEMORY_ADDRESS(ES)```. For instance ```./desym.sh 0x1d6b6b 0x2133bd 0x8b229 ```
