; #############################################################################

        #include "FemtoPass.inc"

; #############################################################################

    DATA SECTION ".data"

; =============================================================================

        #define MAX_PASSWORD         128
        #define MAX_PASSWORD_UTF     (MAX_PASSWORD * 3)

        szConin        dss    "CONIN$", 0h
        szPassword     dss    MAX_PASSWORD dup ?
        szPasswordUtf8 db     MAX_PASSWORD_UTF dup ?
        ddConinHandle  dd     ?
        ddConinMode    dd     ?
        ddCharsRead    dd     ?
        ddBytesInUtf8  dd     ?
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
            je >
            mov [ ddConinHandle ], eax

            inc esi ; 2
            invoke GetConsoleMode, [ ddConinHandle ], ADDR ddConinMode
            or eax, eax
            je >
            mov eax, [ ddConinMode ]

            inc esi ; 3
            and eax, ~ENABLE_ECHO_INPUT
            invoke SetConsoleMode, [ ddConinHandle ], eax
            or eax, eax
            je >

            inc esi ; 4
            invoke ReadConsole, [ ddConinHandle ], ADDR szPassword, MAX_PASSWORD, ADDR ddCharsRead, NULL
            or eax, eax
            je >

            inc esi ; 5
            invoke SetConsoleMode, [ ddConinHandle ], [ ddConinMode ]
            or eax, eax
          : je >

            inc esi ; 6
            mov ebx, [ ddCharsRead ]
            dec ebx
            dec ebx
            invoke WideCharToMultiByte, CP_UTF8, 0, ADDR szPassword, ebx, ADDR szPasswordUtf8, MAX_PASSWORD_UTF, NULL, NULL
            or eax, eax
            je >
            mov [ ddBytesInUtf8 ], eax

            inc esi ; 7
            invoke GetStdHandle, STD_OUTPUT_HANDLE
            cmp eax, INVALID_HANDLE_VALUE
            je >

            inc esi ; 8
            invoke WriteFile, eax, ADDR szPasswordUtf8, [ ddBytesInUtf8 ], ADDR ddBytesWritten, NULL
            or eax, eax
            je >

            inc esi ; 9
            mov eax, [ ddBytesInUtf8 ]
            sub eax, [ ddBytesWritten ]
            jne >
            ;{
                ret
            ;}

          : mov eax, esi
            ret
        ;}

; #############################################################################
