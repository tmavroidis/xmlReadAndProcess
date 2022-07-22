**FREE
 ctl-opt option(*srcstmt) dftactgrp(*no) ;

 dcl-pi xml00;
 PathFile char(200);
 end-Pi;

 dcl-pr OpenFile pointer extproc('_C_IFS_fopen') ;
   *n pointer value ;  //File name
   *n pointer value ;  //File mode
 end-pr ;

 dcl-pr ReadFile pointer extproc('_C_IFS_fgets') ;
   *n pointer value ;  //Retrieved data
   *n int(10) value ;  //Data size
   *n pointer value ;  //Misc pointer
 end-pr ;

 dcl-pr CloseFile extproc('_C_IFS_fclose') ;
   *n pointer value ;  //Misc pointer
 end-pr ;

 dcl-s OpenMode char(5) ;
 dcl-s FilePtr pointer inz ;
 dcl-s RtvData char(32767) ;

 PathFile = %ScanRpl(' ' : x'00' : PathFile);
 OpenMode = 'r' + x'00' ;
 FilePtr = OpenFile(%addr(PathFile):%addr(OpenMode)) ;

 if (FilePtr = *null) ;
   dsply ('fopen unable to open file') ;
   return ;
 endif ;

 dow  (ReadFile(%addr(RtvData):32767:FilePtr) <> *null) ;
   RtvData = %xlate(x'00':' ':RtvData) ;  //End of record null
   RtvData = %xlate(x'25':' ':RtvData) ;  //Line feed (LF)
   RtvData = %xlate(x'0D':' ':RtvData) ;  //Carriage return (CR)

   dsply %subst(RtvData:1:52) ;
   RtvData = ' ' ;
 enddo ;

 CloseFile(%addr(PathFile)) ;
 return ; 
