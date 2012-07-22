; Dialogs:: settings
!verbose 0
!define VAR_0 0 ;$0
!define VAR_1 1 ;$1
!define VAR_2 2 ;$2
!define VAR_3 3 ;$3
!define VAR_4 4 ;$4
!define VAR_5 5 ;$5
!define VAR_6 6 ;$6
!define VAR_7 7 ;$7
!define VAR_8 8 ;$8
!define VAR_9 9 ;$9
!define VAR_R0 10 ;$R0
!define VAR_R1 11 ;$R1
!define VAR_R2 12 ;$R2
!define VAR_R3 13 ;$R3
!define VAR_R4 14 ;$R4
!define VAR_R5 15 ;$R5
!define VAR_R6 16 ;$R6
!define VAR_R7 17 ;$R7
!define VAR_R8 18 ;$R8
!define VAR_R9 19 ;$R9
!define VAR_CMDLINE 20 ;$CMDLINE
!define VAR_INSTDIR 21 ;$INSTDIR
!define VAR_OUTDIR 22 ;$OUTDIR
!define VAR_EXEDIR 23 ;$EXEDIR
!define VAR_LANGUAGE 24 ;$LANGUAGE
!verbose 4


    !macro MoveFile sourceFile destinationFile
	!define MOVEFILE_JUMP ${__LINE__}

	; Check source actually exists

	    IfFileExists "${sourceFile}" +3 0
	    SetErrors
	    goto done_${MOVEFILE_JUMP}

	; Add message to details-view/install-log

	    DetailPrint "Moving/renaming file: ${sourceFile} to ${destinationFile}"

	; If destination does not already exists simply move file

	    IfFileExists "${destinationFile}" +3 0
	    rename "${sourceFile}" "${destinationFile}"
	    goto done_${MOVEFILE_JUMP}

	; If overwriting without 'ifnewer' check

	    ${If} $switch_overwrite == 1
		delete "${destinationFile}"
		rename "${sourceFile}" "${destinationFile}"
		delete "${sourceFile}"
		goto done_${MOVEFILE_JUMP}
	    ${EndIf}

	; If destination already exists

	    Push $R0
	    Push $R1
	    Push $R2
	    push $R3

	    GetFileTime "${sourceFile}" $R0 $R1
	    GetFileTime "${destinationFile}" $R2 $R3

	    IntCmp $R0 $R2 0 older_${MOVEFILE_JUMP} newer_${MOVEFILE_JUMP}
	    IntCmp $R1 $R3 older_${MOVEFILE_JUMP} older_${MOVEFILE_JUMP} newer_${MOVEFILE_JUMP}

	    older_${MOVEFILE_JUMP}:
	    delete "${sourceFile}"
	    goto time_check_done_${MOVEFILE_JUMP}

	    newer_${MOVEFILE_JUMP}:
	    delete "${destinationFile}"
	    rename "${sourceFile}" "${destinationFile}"
	    delete "${sourceFile}" ;incase above failed!

	    time_check_done_${MOVEFILE_JUMP}:

	    Pop $R3
	    Pop $R2
	    Pop $R1
	    Pop $R0

	done_${MOVEFILE_JUMP}:

	!undef MOVEFILE_JUMP
    !macroend


Function FileSizeNew 
	Exch $0
	Push $1
	FileOpen $1 $0 "r"
	FileSeek $1 0 END $0
	FileClose $1
	Pop $1
	Exch $0
FunctionEnd
