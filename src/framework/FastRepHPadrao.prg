#Include "Fivewin.ch"
#Include "FastRepH.ch"
////////////////////////////////////////////////////////////////////////////////
Function FWNewReport(cNamePageFR)

	FrPrn:NewReport(cNamePageFR)
	   PropriedadesFR(cNamePageFR,"Height=1000;Left=0;Top=0;Width=1000;PaperWidth=210;PaperHeight=297;LeftMargin=10;RightMargin=10;TopMargin=10;BottomMargin=10")

Return
////////////////////////////////////////////////////////////////////////////////
Function FWAddPage()

	x:=0
	Do While .T.
		x:=x+1
		cPage:="Page"+Alltrim(Transform(x,"99999999999"))
		IF FrPrn:IsObjectExists(cPage) == .T.
			Loop
		Endif
		FrPrn:AddPage(cPage)
		   PropriedadesFR(cPage,"Height=1000;Left=0;Top=0;Width=1000;PaperWidth=210;PaperHeight=297;LeftMargin=10;RightMargin=10;TopMargin=10;BottomMargin=10")
		Exit
	EndDo
	
Return cPage
////////////////////////////////////////////////////////////////////////////////
Function FWAddPageFooter(cNamePageFooter,cNamePageFR)

	FrPrn:AddBand(cNamePageFooter,cNamePageFR,frxPageFooter)
	   PropriedadesFR(cNamePageFooter,"Height=1N*;Left=0N*;Top=718,1107N*;Width=740,409927N*")

   FrPrn:AddMemo(cNamePageFooter,"LinePageFooter",,0,0,740,1)
      PropriedadesFR("LinePageFooter","Frame.Typ=[ftTop]")

Return
////////////////////////////////////////////////////////////////////////////////
Function FWCab_JatoFR(cNamePageFR,cNameHeaderFR,cCaminhoBmpFR,cTitulo,aTit,aHeaders,lPageHeader,tNomeDaEmpresa,tNomeDoSistema)
	Local cHeightBand:=IIF( LEN(aTit) == 0 .and. LEN(aHeaders) == 0 , '87,2047' , IIF( LEN(aTit) # 0 .and. LEN(aHeaders) == 0 , '106,10235' , '125' ))
	Local lLandScape:= .F.
	Default lPageHeader:=.t.
	IF FrPrn:GetProperty(cNamePageFR,"Orientation") ==  "poLandscape"
      lLandScape:= .T.
	ENDIF

	FrPrn:AddBand(cNameHeaderFR,cNamePageFR,iif(lPageHeader,frxPageHeader,frxHeader))
	   PropriedadesFR(cNameHeaderFR,"Height="+cHeightBand+"N*;ReprintOnNewPage=True")
	
	    IF FILE(cCaminhoBmpFR)
			 FrPrn:AddPicture(cNameHeaderFR,"Picture"+cNameHeaderFR,cCaminhoBmpFR,0,0,132.28355,86.92919)
		      PropriedadesFR("Picture"+cNameHeaderFR,"HightQuality=True")
	    ENDIF

	    nFonttNomeDaEmpresa:="-24"
		 IF LEN(ALLTRIM(tNomeDaEmpresa)) > 30
		    nFonttNomeDaEmpresa:="-14"
		 ENDIF
		 FrPrn:AddMemo(cNameHeaderFR,"Memo1"+cNameHeaderFR,Alltrim(tNomeDaEmpresa),136.06308,0,IIF(lLandScape,793.7013,464.88219),41.57483)
	      PropriedadesFR("Memo1"+cNameHeaderFR,"Font.Height=&nFonttNomeDaEmpresa;Font.Style=[fsBold];HAlign=haCenter")
	
	    FrPrn:AddMemo(cNameHeaderFR,"Memo2"+cNameHeaderFR,Alltrim(tNomeDoSistema),136.06308,41.57483,IIF(lLandScape,793.7013,464.88219),22.67718)
	      PropriedadesFR("Memo2"+cNameHeaderFR,"Font.Height=-17;Font.Style=[fsBold];HAlign=haCenter")
	
	    FrPrn:AddMemo(cNameHeaderFR,"Memo3"+cNameHeaderFR,Alltrim(cTitulo),136.06308,64.25201,IIF(lLandScape,793.7013,464.88219),22.67718)
	      PropriedadesFR("Memo3"+cNameHeaderFR,"Font.Height=-17;HAlign=haCenter")
	
	    FrPrn:AddMemo(cNameHeaderFR,"Memo4"+cNameHeaderFR,'Pagina: [Page#]/[TotalPages#]',IIF(lLandScape,930.03958,605),0,116,18.89765)
	      PropriedadesFR("Memo4"+cNameHeaderFR,"Font.Height=-15;HAlign=haRight")
	
	    FrPrn:AddMemo(cNameHeaderFR,"Memo5"+cNameHeaderFR,'Data: [Date]',IIF(lLandScape,930.03958,605),18.89765,116,18.89765)
	      PropriedadesFR("Memo5"+cNameHeaderFR,"Font.Height=-15;HAlign=haRight")

       nLeftMemosHeader1:=0
	    For N:= 1 to LEN(aTit)
			nLeftMemosHeader1:= nLeftMemosHeader1 + IIF(N == 1 , 0 , aTit[N - 1,2] )
			FrPrn:AddMemo(cNameHeaderFR,"Memo6"+cNameHeaderFR+StrZero(N,3),aTit[N,1],nLeftMemosHeader1,86.92919,aTit[N,2],18.89765)
				PropriedadesFR("Memo6"+cNameHeaderFR+StrZero(N,3),aTit[N,3])
		 Next

		 nLeftMemosHeader2:=0
		 For T:= 1 to LEN(aHeaders)
			nLeftMemosHeader2:= nLeftMemosHeader2 + IIF(T == 1 , 0 , aHeaders[T - 1,2] )
			FrPrn:AddMemo(cNameHeaderFR,"Memo7"+cNameHeaderFR+StrZero(T,3),aHeaders[T,1],nLeftMemosHeader2,105.82684,aHeaders[T,2],18.89765)
				PropriedadesFR("Memo7"+cNameHeaderFR+StrZero(T,3),aHeaders[T,3])
		 Next

Return
////////////////////////////////////////////////////////////////////////////////
Function FWMasterData(cNamePageFR,cNameMasterDataFR,aMasterData,aPropMasterData,nHeightMasterData,nHeightMemo)
	Local nLeftMemosMasterData:=0
	Public I:=1
	Default nHeightMasterData := 18.89765 
	Default nHeightMemo   := 18.89765 
	
	cCampMaster:=""
	For N:=1 to LEN(aMasterData)
		cCampMaster+= "CAMP" + StrZero(N,2) + ";"
		IF N == LEN(aMasterData)
			cCampMaster:=Left(cCampMaster,LEN(cCampMaster)-1)
		ENDIF
	Next
	Public aCampos:=HB_ATokens(cCampMaster,';') // Para controle dos campos e seus valores no SetUserDataSet
	
	cNameDBV:="ITENS"+cNameMasterDataFR
	FrPrn:SetUserDataSet( cNameDBV 															,;
							    cCampMaster														,;
							    {||I := 1} 														,;
							    {||I := I + 1} 													,;
							    {||I := I - 1} 													,;
							    {||I > Len(aMasterData[1])}									,;
    							 {|cField| X:=aMasterData[Ascan(aCampos,cField),I], X})


	FrPrn:AddBand(cNameMasterDataFR,cNamePageFR,frxMasterData)
   	PropriedadesFR(cNameMasterDataFR,"Height="+ alltrim(strtran(transform(nHeightMasterData,"999999999.999999"),'.',',')) +"N*;DataSetName="+cNameDBV)
		For K:= 1 to LEN(aCampos)
			nLeftMemosMasterData:= nLeftMemosMasterData + IIF(K == 1 , 0 , aPropMasterData[K - 1,1] )
			nTopMemosMasterData := iif( nHeightMasterData > nHeightMemo , nHeightMasterData - nHeightMemo , 0 )
			FrPrn:AddMemo(cNameMasterDataFR,"Memo1"+cNameMasterDataFR+aCampos[K],'['+cNameDBV+'."'+aCampos[K]+'"]',nLeftMemosMasterData,nTopMemosMasterData,aPropMasterData[K,1],nHeightMemo)
		   	PropriedadesFR("Memo1"+cNameMasterDataFR+aCampos[K],aPropMasterData[K,2])
		Next

Return

////////////////////////////////////////////////////////////////////////////////
Function FWHeader(cNamePageFR,cNameHeaderFR,aHeader,nHeightHeader,nHeightMemo)
   Local nLeftMemosHeader:=0
   Default nHeightHeader := 18.89765
   Default nHeightMemo := 18.89765
	FrPrn:AddBand(cNameHeaderFR,cNamePageFR,frxHeader)
   	PropriedadesFR(cNameHeaderFR,"Height="+ alltrim(strtran(transform(nHeightHeader,"999999999.999999"),'.',',')) +"N*;ReprintOnNewPage=True")
	
		For Y:= 1 to LEN(aHeader)
			nLeftMemosHeader:= nLeftMemosHeader + IIF(Y == 1 , 0 , aHeader[Y - 1,2] )
			nTopMemosHeader := iif( nHeightHeader > nHeightMemo , nHeightHeader - nHeightMemo , 0 )
			FrPrn:AddMemo(cNameHeaderFR,"Memo"+cNameHeaderFR+StrZero(y,3),aHeader[Y,1],nLeftMemosHeader,nTopMemosHeader,aHeader[Y,2],nHeightMemo)
		   	PropriedadesFR("Memo"+cNameHeaderFR+StrZero(y,3),aHeader[Y,3])
		Next
Return
////////////////////////////////////////////////////////////////////////////////
Function FWFooter(cNamePageFR,cNameFooterFR,aFooter)
   Local nLeftMemosFooter:=0
   
	FrPrn:AddBand(cNameFooterFR,cNamePageFR,frxFooter)
   	PropriedadesFR(cNameFooterFR,"Height=18,89765N*")
	
		For Y:= 1 to LEN(aFooter)
			nLeftMemosFooter:= nLeftMemosFooter + IIF(Y == 1 , 0 , aFooter[Y - 1,2] )
			FrPrn:AddMemo(cNameFooterFR,"Memo"+cNameFooterFR+StrZero(y,3),aFooter[Y,1],nLeftMemosFooter,0,aFooter[Y,2],18.89765)
		   	PropriedadesFR("Memo"+cNameFooterFR+StrZero(y,3),aFooter[Y,3])
		Next
Return
////////////////////////////////////////////////////////////////////////////////
//FUNÇÃO PARA UTILIZA COM O FASTREPORT AONDE DEFINE AS PROPRIEDADES DE DETERMINADO OBJETO
//EX: FrPrn:AddMemo("Page1","Memo1",tNomeDaEmpresa,0,0,75,22)
//    	PropriedadesFR("Memo1","DataField=CODIPRO;DataSetName=ORC;Font.Color=-16777208;Font.Height=-13;Font.Name=Arial;Font.Style=0;Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];HAlign=haCenter;VAlign=vaCenter")
Function PropriedadesFR(oBj,Propriedades)
   Local aPro:={}
   Local aProp:={}

	aPro:=HB_ATokens(Propriedades,";")

   for x:=1 to len(aPro)
      if (AT(".",aPro[x]))>0
         aadd(aProp,Substr(aPro[x],1,AT(".",aPro[x])-1))
         aadd(aProp,Substr(aPro[x],AT(".",aPro[x])+1,AT("=",aPro[x])-(1+AT(".",aPro[x]))))
         aadd(aProp,Substr(aPro[x],AT("=",aPro[x])+1,Len(aPro[x])-AT("=",aPro[x])))
         vPriProp:=aProp[1]
         vSegProp:=aProp[2]
         DO WHILE AT('.',vSegProp) > 0
            vPriProp:=vPriProp+'.'+SubStr(vSegProp,1,At('.',vSegProp)-1)
            vSegProp:=SubStr(vSegProp,At('.',vSegProp)+1,Len(vSegProp))
         ENDDO
         aProp[1]:=vPriProp
         aProp[2]:=vSegProp
         IF right(aProp[Len(aProp)],2) == "N*"
            FrPrn:SetProperty(oBj+'.'+aProp[1],aProp[2],Val(SubStr(strtran(aProp[3],",","."),1,Len(aProp[3])-2)))
         ELSE
            FrPrn:SetProperty(oBj+'.'+aProp[1],aProp[2],aProp[3])
         ENDIF
         aProp:={}
      else
         aadd(aProp,Substr(aPro[x],1,AT("=",aPro[x])-1))
         aadd(aProp,Substr(aPro[x],AT("=",aPro[x])+1,Len(aPro[x])-AT("=",aPro[x])))
         IF right(aProp[2],2) == "N*"
            FrPrn:SetProperty(oBj,aProp[1],Val(SubStr(strtran(aProp[2],",","."),1,Len(aProp[2])-2)))
         ELSE
            FrPrn:SetProperty(oBj,aProp[1],aProp[2])
         ENDIF
         aProp:={}
      endif
   next

Return .t.
//Exemplo:
//FrPrn:SetProperty( "Memo1.Font"     , "Style" , "[fsBold]"      )
//FrPrn:SetProperty( "Nome_Memo.Font" , "Color" , CLR_RED         )
//FrPrn:SetProperty( "Nome_Memo.Font" , "Name"  , 'MS Sans Serif' )
//FrPrn:SetProperty( "Nome_Memo"      , "Color" , CLR_BLUE        )
//FrPrn:SetProperty( "Nome_Memo.Memo" , "Text"  , "novo_texto"    )
////////////////////////////////////////////////////////////////////////////////
Function PadraoFastReport(lImprimirSemPreview,pImpressora,lPedeImpressora,nCopiasFR)
	Local lRetornoPreparacao:=.f.,printername:=""
	Default lImprimirSemPreview:=.f.,pImpressora:="",lPedeImpressora:=.f.,nCopiasFR:=0
	CursorWait()
	if empty(pimpressora)
			printername:=prngetname()
	else
	   printername:=pimpressora
	endif
	if nCopiasFR > 0
		FrPrn:PrintOptions:SetCopies(nCopiasFR)
	endif	
	if lPedeImpressora
		FrPrn:PrintOptions:SetPrinter(PrinterName)
		FrPrn:PrintOptions:SetShowDialog(.t.)
	else
		FrPrn:PrintOptions:SetPrinter(PrinterName)
		FrPrn:PrintOptions:SetShowDialog(.F.)
	endif
	FrPrn:PreviewOptions:SetButtons(FR_PB_PRINT+FR_PB_EXPORT+FR_PB_ZOOM+FR_PB_FIND+FR_PB_OUTLINE+FR_PB_PAGESETUP+FR_PB_TOOLS+FR_PB_NAVIGATOR+FR_PB_PDFANDMAIL)
	if File("c:\desenv.sys")
		Cursor()
		FrPrn:DesignReport()
	else
		if lImprimirSemPreview
			FrPrn:PrepareReport()
   		FrPrn:Print()
   		Cursor()
   	else	
			MsgRunEsc("Preparando relatório","Aguarde um momento",{||lRetornoPreparacao:=(FrPrn:PrepareReport(.t.))})
			if lRetornoPreparacao
				Cursor()
				FrPrn:ShowPreparedReport()
			else
			   MsgStop("Ocorreu um problema na preparação do relatório!","Ocorreu um problema")
			endif	
		endif	
	endif
	FrPrn:DestroyFR()
	Cursor()
	Try
		BringWindowToTop(oWndPrin:hWnd)
	Catch
	end	
	SysRefresh()
Return
////////////////////////////////////////////////////////////////////////////////
Function PropriedadeFREmail(tPortaSMTP,tHostSMTP,tTimeOut,tName,tYourEmail,tSenha,tText,tAssunto,tAddress,tAssinatura,tNomeFantasia)
	*E-Mail*
	FrPrn:SetProperty("MailExport"		, "Address"				, tAddress 			) 	//Endereço do destinatario do e-mail
	FrPrn:SetProperty("MailExport"		, "Subject"				, tAssunto			) 	//Assunto do e-mail
	FrPrn:SetProperty("MailExport.Lines", "Text"					, tText				)  //Conteudo do e-mail
	FrPrn:SetProperty("MailExport"		, "ShowDialog"			, .T. 				)	//Mostrar ou não a tela de exportação, a do e-mail e as caracteristicas do PDF.
	FrPrn:SetProperty("MailExport"		, "ShowExportDialog"	, .F. 				)	//Ativar/Desativar a marcação para opções avançadas de exportação.
	if !Empty(tYourEmail)
		FrPrn:SetProperty("MailExport"		, "FromMail"			, tYourEmail 		)	//Email de quem está enviando
	else	
		FrPrn:SetProperty("MailExport"		, "FromMail"			, vconsmtp 		)	//Email de quem está enviando
	endif	
	FrPrn:SetProperty("MailExport"		, "FromName"			, tName 				)	//Nome de quem está enviando
	FrPrn:SetProperty("MailExport"		, "FromCompany"		, tNomeFantasia 	)	//'Organização'
	FrPrn:SetProperty("MailExport.Signature", "Text"			, tAssinatura		)	//Assinatura
	FrPrn:SetProperty("MailExport"		, "SmtpHost"			, tHostSMTP 		)	//Host  SMTP
	FrPrn:SetProperty("MailExport"		, "SmtpPort"			, tPortaSMTP  		)	//Porta SMTP
	FrPrn:SetProperty("MailExport"		, "Login"				, vConsmtp  		)	//Login  // Variavel PUBLICA carregada no inicio da aplicação 
	FrPrn:SetProperty("MailExport"		, "Password"			, tSenha 			)	//Senha
	IF FILE("C:\desenv.sys")
		FrPrn:SetProperty("MailExport"		, "LogFile"				, .t. 				)	//
	endif
	FrPrn:SetProperty("MailExport"		, "ConfirmReading"	, .F. 				)	//Mostrar se a pessoa recebeu o e-mail ou não 
	FrPrn:SetProperty("MailExport"		, "TimeOut"				, tTimeOut			)	//Time Out //Está abaixo da porta SMTP
	FrPrn:SetProperty("MailExport"		, "UseIniFile"			, .F. 				)	//Usar arquivo que o FR Gera para autopreencher os campos a cima
	FrPrn:SetEventHandler("MailExport","OnSendMail",{|ParamsArray| SendMail_FR(FrPrn,ParamsArray)}) 
	*PDF*
	FrPrn:SetProperty("PDFExport"		, "Title"		, "" )
	FrPrn:SetProperty("PDFExport"		, "Author"		, "" )
	FrPrn:SetProperty("PDFExport"		, "Subject"		, "" )
	FrPrn:SetProperty("PDFExport"		, "Keywords"	, "" )
	FrPrn:SetProperty("PDFExport"		, "Creator"		, "" )
	FrPrn:SetProperty("PDFExport"		, "Producer"	, "" )
	FrPrn:SetProperty("PDFExport"		, "EmbeddedFonts"	, .T. )

Return
function SENDMAIL_FR_EXTRA(FrPrn,ParamsArray,aFiles)
			SENDMAIL_FR(FrPrn,ParamsArray,aFiles)
function SENDMAIL_FR(FrPrn,ParamsArray,aFiles)
   //? FrPrn,valtoprg(ParamsArray)
   DEFAULT aFiles :={}
	Public lRet  := .f.
   Public oCfg  , oError
   Public cServ , nPort
   Public cUser , cPass
   Public lAut  , lSSL

	* Variaveis do FASTReport
	
	cServer        := alltrim(ParamsArray[1])
	nPort          := ParamsArray[2]
	cUserField     := alltrim(ParamsArray[3])
	cPasswordField := alltrim(ParamsArray[4])
	cFromField     := alltrim(ParamsArray[5])
	cToField       := alltrim(strtran(ParamsArray[6],',',';'))
	cSubjectField  := alltrim(ParamsArray[7])
	cCompanyField  := alltrim(ParamsArray[8])
   cTextField     := alltrim(ParamsArray[9])
	cFileNames     := alltrim(ParamsArray[10])
	nTimeOut       := ParamsArray[11]
	*cReplyToField  := ALLTRIM(vCORREIOemp)
	/*
	if Carrega_Dados_SMTP_Usuario()
      cServer          := alltrim(tusuario_email_hoste)
      nPort            := val(tusuario_email_porte)
      vautessl         := tusuario_email_sslal
      cUserField       := alltrim(tusuario_email_usuae)
      cFromField       := alltrim(tusuario_email_usuae)
      cPasswordField   := alltrim(tusuario_email_senhe)
      cReplyToField    := alltrim(tusuario_email_reply)
      *acemod("Acionou o envio de e-mail para "+alltrim(cToField)+" sobre "+alltrim(cSubjectField)+" do IP "+Tcpip())
	endif
	*/
	* preenche as variaveis de trabalho
   * Cadastro todo perfeito para transmissão usando o smtp da inteligence
   cServ := cServer
   nPort := str(nPort,10,0,.t.)
   cUser := cUserField
   cPass := cPasswordField
   lAut  := .t. // Até agora todos os smtps que tenho conhecimento tem Autenticação SMTP.
   lSSL  := .t. // Autenticação SSL para o servidor do smtp , as vezes marcado e melhor para transmitir.

   TRY
      oCfg := TOleAuto():New( "CDO.Configuration" )
      WITH OBJECT oCfg:Fields
      :Item( "http://schemas.microsoft.com/cdo/configuration/smtpserver"       ):Value := cServ
      :Item( "http://schemas.microsoft.com/cdo/configuration/smtpserverport"   ):Value := nPort
      :Item( "http://schemas.microsoft.com/cdo/configuration/sendusing"        ):Value := 2
      :Item( "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate" ):Value := 1
      :Item( "http://schemas.microsoft.com/cdo/configuration/smtpusessl"       ):Value := lSSL
      :Item( "http://schemas.microsoft.com/cdo/configuration/sendusername"     ):Value := cUser
      :Item( "http://schemas.microsoft.com/cdo/configuration/sendpassword"     ):Value := cPass
      :Item( "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout"):Value := 60 
      :Update()
   END WITH
   lRet := .t.
   CATCH oError
   MsgInfo( "Não Foi possível Enviar o e-Mail! Erro Configuração "  +CRLF+ ;
    "Error: "     + Transform(oError:GenCode,   nil) + ";" +CRLF+ ;
    "SubC: "      + Transform(oError:SubCode,   nil) + ";" +CRLF+ ;
    "OSCode: "    + Transform(oError:OsCode,    nil) + ";" +CRLF+ ;
    "SubSystem: " + Transform(oError:SubSystem, nil) + ";" +CRLF+ ;
    "Mensaje: "   + oError:Description, "Atenção" )
   END
   if lRet
       MsgRun("Aguarde enviando e-mail....","Aguarde ...",{|| Envia_Mail_Anexo(oCfg,cFromField,cToField,cSubjectField,cCompanyField,cTextField,cFileNames,aFiles,cReplyToField)})
   endif
   
   Return ""
Function Envia_Mail_Anexo(oCfg,cFromField,cToField,cSubjectField,cCompanyField,cTextField,cFileNames,aFiles,cReplyToField)
   local aAttach := {}, aTo := ""
   local cToken
   local nEle
   local oMsg
   local cFrom, cSubject, cMsg, cAttach,cReplyTo
	// FWDBG oCfg,cFromField,cToField,cSubjectField,cCompanyField,cTextField,cFileNames,aFiles
   cReplyTo  :=  cReplyToField          //--> DE
   cFrom     :=  cFromField          //--> DE
   aTo       :=  Alltrim(cToField)                     //--> PARA	- CLIENTE - COM COPIA
   ** cCC       :=  "inteligence.informatica@gmail.com"  //--> PARA	- CLIENTE - COM COPIA
   ** cBcc      :=  ""
   cSubject  := cSubjectField  //--> ASSUNTO
   * CORPO DO EMAIL
   cMsg      := cTextField
   cAttach   := cFileNames                                                                    // ANEXO
   nEle      := 1
	While ! Empty( cToken := StrToken( cAttach, nEle++, "," ) )
      AAdd( aAttach,  SubStr(cToken,1, IIF( At("=",cToken) > 0 ,At("=",cToken)-1, len(cToken) )) )
   End
   FOR nArquivo := 1 to len(aFiles)
		aadd(aAttach,aFiles[nArquivo])
   next	
	TRY
	   oMsg := TOleAuto():New( "CDO.Message" )
	   
		WITH OBJECT oMsg
		   :Configuration = oCfg
			:From = cFrom
			:To = aTo
			:Subject = cSubject
			:ReplyTo = cReplyTo
			:TextBody = cMsg
		   For x := 1 To Len( aAttach )
				:AddAttachment(AllTrim(aAttach[x]))
		   Next
			:Send()
		END WITH
		MsgInfo("E-mail enviado com sucesso !!! a mensagem: "+CRLF+alltrim(cSubject)+" para o e-Mail: "+aTo,"Atenção")
	CATCH oErro
		MsgInfo("Erro, não foi possível enviar a Mensagem: " +CRLF+alltrim(cSubject)+" para o e-Mail: "+aTo,"Atenção")
	END
   Return nil
         
         
////////////////////////////////////////////////////////////////////////////////
Function FastReportModelo1(cTitulo,aHeaders,aMasterData,aFooter,Extra,lImprimirSemPreview,pImpressora,lPedeImpressora,nCopiasFR,cLogoEmpresa,tNomeDaEmpresa,tNomeDoSistema)
   Local nCont1, nCont2, aPropMasterData:=CriaArray(LEN(aHeaders)-1), aHeaders2:=CriaArray(LEN(aHeaders)-1)
   Public FrPrn:=frReportManager():new()

	FWNewReport("Modelo1")

	For nCont1:=1 to (LEN(aHeaders) - 1)
      aHeaders2[nCont1]:=aHeaders[nCont1+1]                                     
 	Next
	FWCab_JatoFR("Modelo1","PageHeaderModelo1",iif(file(cLogoEmpresa),cLogoEmpresa,""),cTitulo,{aHeaders[1]},aHeaders2,,tNomeDaEmpresa,tNomeDoSistema)

	If LEN(aFooter)#0
   	FWFooter("Modelo1","FooterModelo1",aFooter)
   		PropriedadesFR("FooterModelo1","Top=2N*")
	Endif

	For nCont2:=1 to (LEN(aHeaders) - 1)
      aPropMasterData[nCont2]:={aHeaders[nCont2+1,2], StrTran(aHeaders[nCont2+1,3],'Font.Style=[fsBold];','')}
 	Next

	FWMasterData("Modelo1","MasterDataModelo1",aMasterData,aPropMasterData)
      PropriedadesFR("MasterDataModelo1","Top=1N*")

	IF !EMPTY(Extra)
		Try
		  &Extra()
  		Catch
   	  &Extra
	   end
  	ENDIF

 	IF EMPTY(cTitulo)
      FrPrn:SetFileName("Arquivo.pdf")
	Else
		FrPrn:SetFileName(Alltrim(cTitulo)+".pdf")
	ENDIF
   
	*PropriedadeFREmail(ALLTRIM(STR(vPORSMTP)),ALLTRIM(vSMTPHOS),120,tNomeDaEmpresa,ALLTRIM(vEMAILDE),ALLTRIM(vSENSMTP),"Segue Anexo o "+cTitulo+" Como Combinado."+CRLF+"Obrigado Pela Preferência.",cTitulo,/*Alltrim(CLI->CORREIO)*/,CRLF+"--"+CRLF+tNomeDaEmpresa+CRLF+ALLTRIM(vENDERECemp)+", "+vNUMEROSemp+CRLF+'CEP: '+ALLTRIM(vNUMECEPemp)+' - '+ALLTRIM(vCIDA_DEemp)+"-"+ALLTRIM(vESTA_DOemp)+CRLF+'Fone: '+ALLTRIM(vTELE_FOemp)+'  -  Fax:'+ALLTRIM(vNUMEFAXemp)+CRLF+'E-mail: '+ALLTRIM(vCORREIOemp)+CRLF+xINTERNE)
	IF LEN(aMasterData[1]) == 0
      MsgInfo("Não existem informações para imprimir...","Atenção")
		FrPrn:DestroyFR()
      Return .F.
   ELSE
      PadraoFastReport(lImprimirSemPreview,pImpressora,lPedeImpressora,nCopiasFR)
   ENDIF
Return .t.
////////////////////////////////////////////////////////////////////////////////
Function InverteMatriz(aVetorEntrada)
	Local aVetorSaida

	Set century off
	Try
		aVetorSaida:=CriaArray(LEN(aVetorEntrada[1]))
		For I:=1 to LEN(aVetorEntrada)
			For A:=1 to LEN(aVetorSaida)
				AADD(aVetorSaida[A],StrTran(cValtoChar(aVetorEntrada[I,A]),'00:00:00.000',''))
			Next
		Next
	Catch
	   aVetorSaida:=CriaArray(LEN(aVetorEntrada))
		For A:=1 to LEN(aVetorEntrada)
			AADD(aVetorSaida[A],StrTran(cValtoChar(aVetorEntrada[A]),'00:00:00.000',''))
		Next
	End
   Set century on
Return aVetorSaida
////////////////////////////////////////////////////////////////////////////////
Function CriaArray(nArrays)
   aArray:={}
   For U:=1 to nArrays
      AADD(aArray,Array(0))
   Next
   Return aArray
Function Tcpip()
   Local cret:="#Error"
   if wsastartup()!=0
      msginfo("Erro na Autenticação de TCP/IP","Informação")
      return(cret)
   endif
   cret:=alltrim(padr(gethostbyname(gethostname()),15))
   return(cret)
function MsgRunEsc( cCaption, cTitle, bAction )

     LOCAL oDlg, nWidth, uReturn

     DEFAULT cCaption := "Please, wait...",;
             bAction  := { || WaitSeconds( 1 ) }

     IF cTitle == NIL
          DEFINE DIALOG oDlg ;
               FROM 0,0 TO 3, Len( cCaption ) + 4 ;
               STYLE nOr( DS_MODALFRAME, WS_POPUP )
     ELSE
          DEFINE DIALOG oDlg ;
               FROM 0,0 TO 4, Max( Len( cCaption ), Len( cTitle ) ) + 4 ;
               TITLE cTitle ;
               STYLE DS_MODALFRAME
     ENDIF

     oDlg:bStart := { || uReturn := Eval( bAction, oDlg ), oDlg:End(), SysRefresh() }
     oDlg:cMsg   := cCaption

     nWidth := oDlg:nRight - oDlg:nLeft

     ACTIVATE DIALOG oDlg CENTER ;
          ON PAINT oDlg:Say( 11, 0, xPadC( oDlg:cMsg, nWidth ),,,, .T., .T. ) VALID !( GetKeyState( 27 ) )

return uReturn

Function Criar_Registro_Array(lAppendBlank)
   local cFieldList,bLine
   Default lAppendBlank := .T.
   *
   SELECT ALIAS()
   *
   cFieldList  := ""
   IF lAppendBlank
      AEval( DbStruct(), { |a| cFieldList += "," + "uValBlank("+a[ 1 ]+")" } )
   ELSE
      AEval( DbStruct(), { |a| cFieldList += ","+a[ 1 ] } )
   ENDIF
   	
   cFieldList  := Substr( cFieldList, 2 )
   bLine    := &( "{||{" + cFieldList + "}}" )
   return bLine
Function Criar_Variveis_Tabela(lAppendBlank,lCriaObjetos)
   Local cAlias , aEstrutura , cConstante
   *
   Default lAppendBlank := .f.,lCriaObjetos:=.t.
   *
   SELECT ALIAS()
   *
   cAlias     := Alias()
   *
   aEstrutura := &(cAlias)->(DbStruct())
   *
   for nCampo := 1 to len(aEstrutura)
      cVariavel := "v"+aEstrutura[nCampo][1]
      cObjeto   := "o"+aEstrutura[nCampo][1]
      IF lAppendBlank
         public &cVariavel := uValBlank(&(cAlias)->(FieldGet(nCampo)))
      ELSE
         public &cVariavel := &(cAlias)->(FieldGet(nCampo))
      ENDIF
      if lCriaObjetos
         public &cObjeto := NIL
      endif
   next
Function Criar_Constante_Array()
   Local cAlias , aEstrutura , cConstante
	*
   SELECT ALIAS()
   
   cAlias     := Alias()
	aEstrutura := &(cAlias)->(DbStruct())
   *
	for nCampo := 1 to len(aEstrutura)
		cConstante := cAlias+"_"+aEstrutura[nCampo][1] 
		public &cConstante := &(cAlias)->(FieldPos(aEstrutura[nCampo][1]))
	next 
