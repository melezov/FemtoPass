; #############################################################################

        #include "FemtoPass.inc"

; #############################################################################

    DATA SECTION ".data"

; =============================================================================

        #define MAX_PASSWORD 1024

        szConin        dss    "CONIN$", 0h
        szPassword     dss    MAX_PASSWORD dup ?
        ddConinHandle  dd     ?
        ddConinMode    dd     ?
        ddCharsRead    dd     ?
        ddBytesWritten dd     ?

; #############################################################################

    CODE SECTION ".text"

; =============================================================================

        FemtoPass_Entry:
        ;{
            xor esi, esi
            inc esi ; 1
            invoke CreateFile, ADDR szConin, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
            cmp eax, INVALID_HANDLE_VALUE
            je >>.exit
            mov [ ddConinHandle ], eax

            inc esi ; 2
            invoke GetConsoleMode, [ ddConinHandle ], ADDR ddConinMode
            or eax, eax
            je >>.exit
            mov eax, [ ddConinMode ]
            
            inc esi ; 3
            and eax, ~ENABLE_ECHO_INPUT
            invoke SetConsoleMode, [ ddConinHandle ], eax
            or eax, eax
            je >.exit

            inc esi ; 4
            invoke ReadConsole, [ ddConinHandle ], ADDR szPassword, MAX_PASSWORD, ADDR ddCharsRead, NULL
            or eax, eax
            je >.exit

            inc esi ; 5
            invoke SetConsoleMode, [ ddConinHandle ], [ ddConinMode ]
            or eax, eax
            je >.exit

            inc esi ; 6
            invoke GetStdHandle, STD_OUTPUT_HANDLE
            cmp eax, INVALID_HANDLE_VALUE
            je >.exit

            inc esi ; 7
            invoke WriteFile, eax, ADDR szPassword, [ ddCharsRead ], ADDR ddBytesWritten, NULL
            or eax, eax
            je >.exit

            inc esi ; 8
            mov eax, [ ddCharsRead ]
            sub eax, [ ddBytesWritten ]
            jne >.exit
            ;{
                ret
            ;}

        .exit:
            mov eax, esi
            ret
        ;}

; #############################################################################
