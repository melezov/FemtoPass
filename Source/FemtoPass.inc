; #############################################################################

    #ifndef _FEMTOPASS_INC_
    #define _FEMTOPASS_INC_
    ;{

; #############################################################################

        #ifdef UNICODE
        ;{
            #define dss dus
            #define AW  W
            #define S   2
        ;}
        #else
        ;{
            #define dss db
            #define AW  A
            #define S   1
        ;}
        #endif // UNICODE

; #############################################################################

        #define MAX_PASSWORD                80h

; =============================================================================

        #define NULL                         0h

        #define GENERIC_READ          80000000h
        #define GENERIC_WRITE         40000000h

        #define FILE_SHARE_READ              1h
        #define OPEN_EXISTING                3h
        #define FILE_ATTRIBUTE_NORMAL       80h

        #define ENABLE_ECHO_INPUT            4h

        #define INVALID_HANDLE_VALUE        -1
        #define STD_OUTPUT_HANDLE          -11

; =============================================================================

        #define IMP

        #define CreateFile       IMP ## CreateFile  ## AW
        #define ReadConsole      IMP ## ReadConsole ## AW

; =============================================================================

    ;}
    #endif // _FEMTOPASS_INC_

; #############################################################################
