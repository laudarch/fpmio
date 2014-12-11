Documentation io.asm
=====

Simple Input-Output library for MASM. The io.asm source code and readme files. Created for the MASM32 and can work in virtual machines (Tested using Virtual Box with Windows XP).

*This version is update for the [github repository](https://github.com/KubSU/SIOMASM).*

***For update download [archive](https://github.com/fpm2014/fpmio/archive/master.zip), unzip and open `update.bat`*** 
At the command prompt will be informed about the successful copying files. If an error occurs, then copy the file to the folder `io.asm`` c: \ masm32 \ include \ `. If a Command Prompt window momentarily closed (insufficient access rights) - copy the file `io.asm` to any folder and list the full name of` io.asm` in the project.

## Installing IDE RadASM

- Set of MASM `Install / masm32v11r.zip`. Necessarily in the root directory of the drive `C: \`.
- Set the input-output library by running the administrator `Install \ InstallLibs.bat`.
- Unpack `Install / RadASM.zip` in any convenient location on the disc` C: \ `.

## Use of registers in the IDE RadASM

**Note**: When running on a virtual machine registers do not work correctly. Recommended for solutions to this problem used to index the array of looping and use only 32-bit `registry` otherwise rabrotosposobnost and compatibility can not be guaranteed.

## Sample Program (Hello World!)

```nasm
.686; Processor architecture i686
include /masm32/include/io.asm      ; Includes a library of input-output

.data                               ; Data segment
     msgHello db "Hello World!", 0  ; Definition of string variable

.code; code segment
start:
     print offset msgHello          ; Displays a message
     print                          ; Looking forward to pressing any key
     exit                           ; Terminate the program
end start                           ; Definition of point of entry into the program
```

## Macros
*Brackets indicate further that the argument can be omitted.*
*Under the implied registers 4 main register EAX, EBX, ECX, EDX, and parts thereof.*

### I. Macros for working with strings and symbols
Macro | Description
:----------------:|---------
`print [arg]` | `arg` If you register or variable size in bytes, the macro displays a character with code stored in them. If `arg` the first character of the string, the macro displays the string. If `arg` direct line, the macro displays the string. If `arg` missing, the macro waits for pressing any key. **Features** *No need to use the offset. You can not display an empty string. Only need to use double quotes.*
`println [arg]` | Similar `print`, but with the transition to a new line after the withdrawal.
`read arg` | If `arg` register or variable size in bytes, the macro code reads into it pressed. **Features** *It is recommended to use as an argument to register, since then provided input horizontally. You can not use registers or variables larger than bytes.*
`readln arg` | Similar `read`, but with the transition to a new line after entering.

### II. Macros for working with integers
Macro | Description
:----------------:|---------
`outint num` | Macro automatically defines a macro to display the sign values in decimal or register variable `num`. **Features** *To display an array, use macros `outint8`,` outint16`, `outint32`*
`inint num` | Macro automatically defines a macro to enter the sign values in decimal notation in the register or variable `num`. **Features** *To enter an array, use macros `inint8`,` inint16`, `inint32`*
`outint32 num`, `outint16 num`, `outint8 num` | Macro displays a symbolic number in the decimal system from the register or variable sizes 32, 16 and 8 bits, respectively.
`inint32 num`, `inint16 num`, `inint8 num` | Macro introduces a symbolic number in the decimal system in the register or variable sizes 32, 16 and 8 bits, respectively.

### III. Macros old version (for compatibility with older programs)
Please try not to use the following macros.

Macro | Description
:----------------:|---------
`inch char` | Same as `read` (use `read`).
`outch [char]` | Same as `print` (use `print`).
`inkey [text]` | Displays the direct line `text`, and waits for pressing any key. (copied from macro.asm to solve corruption registers).
`newline` | Start a new line.
`outstr offset str` | Print a line `str` using `offset`.
`outstrln offset str` | Print a line `str` using `offset`, with the transfer to a new line.

## What's new

1. Fixed a bug with the output macros `outint8` and` outint16` signed numbers.
2. Macros O `outint8`, `outint16`, `outint32` automatically selected when using the macro `outint`.
3. Macros input `inint8`, `inint16`, `inint32` automatically selected when using the macro `inint`.
4. Enter the new macro `print` / `println` and `read` / `readln` (details in the description above).
5. The macro `inch` now works with all major 8 bit registers.
6. Macro `inch` now supports input horizontally.
6. Fixed a bug with the departure of the program for the macro `outch` (use `print`).
7. The macro `inkey` no longer corrupts the registers.
