#Include "Entidade.CH"
*
Function Main()
   Local oUsuario
	*
	SET DELE ON
   SET CENT ON
   SET DATE BRIT
   SET EPOCH TO 1980
   SET MULTIPLE ON
   *
   SET 3DLOOK ON
   SET SOFTSEEK OFF
   SET CONFIRM ON 
   sethandlecount(250)
   SetBalloon( .T. )  
   *
   REQUEST SQLRDD
   RDDSETDEFAULT("SQLRDD")
	*
	IF !File("SQL.CONFIG")
		CreateCONFIGMySQL()		
	ELSE
		ConnectCONFIGMySQL()
	ENDIF	
	*
	ManterTabela()
	*
	oManter := ManterUsuario():New()
