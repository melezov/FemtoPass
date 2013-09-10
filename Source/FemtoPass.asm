; #############################################################################

        #include "FemtoPass.inc"

; #############################################################################

        #define MAX_PASSWORD          400h
        #define MAX_PASSWORD_UNICODE  (MAX_PASSWORD * 2)
        #define MAX_PASSWORD_UTF8     (MAX_PASSWORD * 3)

; #############################################################################

    CODE SECTION ".text"

; =============================================================================

        FemtoPass_Entry:
        ;{
            sub esp, MAX_PASSWORD_UNICODE + MAX_PASSWORD_UTF8

            xor ebp, ebp
            inc ebp ; 1
            invoke CreateFileA, ADDR szConin, GENERIC_READ | GENERIC_WRITE, ebp /* FILE_SHARE_READ */, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
            inc eax
            je >
            dec eax
            mov ebx, eax

            inc ebp ; 2
            push esp
            invoke GetConsoleMode, ebx, esp
            pop esi
            test eax, eax
            je >

            inc ebp ; 3
            and esi, ~ENABLE_ECHO_INPUT
            invoke SetConsoleMode, ebx, esi
            test eax, eax
            je >

            inc ebp ; 4
            mov ecx, esp
            push esp
            mov edx, esp
            invoke ReadConsoleW, ebx, ecx, MAX_PASSWORD, edx, NULL
            pop edi
            test eax, eax
            je >

            inc ebp ; 5
            invoke SetConsoleMode, ebx, esi
            test eax, eax
          : je >

            inc ebp ; 6
            xor eax, eax
            mov ecx, esp
            dec edi
            dec edi
            mov ebx, MAX_PASSWORD_UTF8
            lea edx, [ esp + ebx ]
            invoke WideCharToMultiByte, CP_UTF8, eax, ecx, edi, edx, ebx, eax, eax
            test eax, eax
            je >
            mov esi, eax

            inc ebp ; 7
            invoke GetStdHandle, STD_OUTPUT_HANDLE
            inc eax
            je >
            dec eax

            inc ebp ; 8
            lea ecx, [ esp + ebx ]
            push esp
            mov edx, esp
            invoke WriteFile, eax, ecx, esi, edx, NULL
            pop ebx
            test eax, eax
            je >

            inc ebp ; 9
            mov eax, esi
            sub eax, ebx
            je >.end

          : mov eax, ebp
      .end: add esp, MAX_PASSWORD_UNICODE + MAX_PASSWORD_UTF8
            ret
        ;}

; #############################################################################

      szConin: db "CONIN$", 0h

; #############################################################################
