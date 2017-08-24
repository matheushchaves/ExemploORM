#Include "Entidade.CH"

Class ManterUsuario 
		*
		DATA oControle 
		DATA cAlias
		*
		Method New() CONSTRUCTOR
		Method Incluir(oBrw)
		Method Alterar(oBrw,nID)
		Method Excluir(oBrw,nID)
		Method Imprimir() 
EndClass
Method New() Class ManterUsuario
		Local oDlg, oBar, oFont, oSegoe, oBrw
		Local oUsuario := Usuario():New()
		*		 
		::oControle := Tabela():New(oUsuario)
		*	
		IF !::oControle:Usar(.t.)
		   RETURN nil
		ENDIF
		
		::cAlias := ::oControle:PegarAlias()
		*
		DEFINE FONT oFont  NAME "ARIAL"     SIZE 0,-12 BOLD
		DEFINE FONT oSegoe NAME "Segoe UI"  SIZE 0,-14
		*
		DEFINE DIALOG oDlg SIZE 600,400 PIXEL TRUEPIXEL FONT oFont ;
		 TITLE "Manter Usuário"
		
		DEFINE BUTTONBAR oBar OF oDlg SIZE 80,30 NOBORDER 2013 3DLOOK
		
		DEFINE BUTTON OF oBar PROMPT "Adicionar" ACTION ::Incluir(oBrw)
		DEFINE BUTTON OF oBar PROMPT "Editar"    ACTION ::Alterar(oBrw,(::cAlias)->nID) 
		DEFINE BUTTON OF oBar PROMPT "Remover"   ACTION ::Excluir(oBrw,(::cAlias)->nID) 
		DEFINE BUTTON OF oBar PROMPT "Imprimir"  ACTION ::Imprimir() 
		DEFINE BUTTON OF oBar PROMPT "Retornar"  GROUP ACTION oDlg:End()
		
		@ 0,0 XBROWSE oBrw OF oDlg DATASOURCE ::cAlias ;
		 FIELDS (::cAlias)->nID,(::cAlias)->cNome,(::cAlias)->lAdministrador;
       FIELDSIZES 100,400,50 ;
       HEADERS "ID","Nome","Admin";
		 FONT oSegoe ;
		 FOOTERS NOBORDER CELL LINES
		
		oBrw:Admin:SetCheck() 
		
		oBrw:CreateFromCode()
		oDlg:oClient := oBrw
		
		ACTIVATE DIALOG oDlg CENTERED ON INIT oDlg:Resize()
		RELEASE FONT oFont, oSegoe
RETURN SELF		

Method Incluir(oBrw) Class ManterUsuario
		 Local oUsuario := Usuario():NewModel()
		 Local lConfirmar,nID:=0
		 *
		 lConfirmar := EDITVARS oUsuario:cNome,oUsuario:cSenha,oUsuario:lAdministrador PROMPTS "Nome","Senha","Administrador" ;
		 					VALIDS {|| !Empty(oUsuario:cNome) },{|| !Empty(oUsuario:cSenha) } ;
							 PICTURES "@!",.t.,NIL TITLE "Incluir Usuário"
		 *
		 if lConfirmar
		    oUsuario:cSenha:= Protege(oUsuario:cSenha,"1qaz")
		    nID := ::oControle:Incluir(oUsuario)
		 endif	
		 if nID > 0
		    MsgInfo("Registro incluído com sucesso!","Informação")
		 endif						 	
		 oBrw:Refresh()

Method Alterar(oBrw,nID) Class ManterUsuario
		 Local oUsuario := Usuario():NewModel()
		 Local lConfirmar,tID:=0
		 *
		 IF nID == 0
		    RETURN 
		 ENDIF 
		 oUsuario := ::oControle:PegarModel(nID)
		 *
		 oUsuario:cSenha:= DesProtege(oUsuario:cSenha,"1qaz")
		 *
		 lConfirmar := EDITVARS oUsuario:cNome,oUsuario:cSenha,oUsuario:lAdministrador PROMPTS "Nome","Senha","Administrador" ;
		 					VALIDS {|| !Empty(oUsuario:cNome) },{|| !Empty(oUsuario:cSenha) } ;
							 PICTURES "@!",.t.,NIL TITLE "Alterar Usuário"
		 *
		 if lConfirmar
		    oUsuario:cSenha:= Protege(oUsuario:cSenha,"1qaz")
			 tID := ::oControle:Alterar(oUsuario,nID)
		 endif	
		 *
		 if tID > 0
		    MsgInfo("Registro alterado com sucesso!","Informação")
		 endif						 	
		 oBrw:Refresh()

Method Excluir(oBrw,nID) Class ManterUsuario
		 if MsgYesNo("Deseja realmente excluir esse registro?","Pergunta")
		    if ::oControle:Remover(nID) 
		       MsgInfo("Registro excluído com sucesso!","Informação")
			 endif
		 endif
       oBrw:Refresh()
Method Imprimir()  Class ManterUsuario 
       *
       cTitulo := "Relação de Usuários"
		 aDados:={}
		 aHeaders:={}
		 aMasterData:={}
		 aFooter:={}
		 *
       cPropriedadePadrao_Headers:="Font.Height=-11;Font.Name=Courier New;Font.Style=[fsBold];Frame.Typ=[ftLeft,ftRight,ftBottom,ftTop];"
		 *
		 Select(::cAlias)
		 ::oControle:Ordenar("NOME")
		 While (::cAlias)->(!Eof())
		       aadd(aDados,{(::cAlias)->nID,(::cAlias)->cNome,iif((::cAlias)->lAdministrador,"Sim","Não")})
		 		 Select(::cAlias)      
		 		 (::cAlias)->(DbSkip())
		 End
		 *
		 if len(aDados) == 0
 		    MsgInfo("Não existe informações para imprimir!","Atenção")
 		    return 
       endif
		 *
		 aMasterData:=InverteMatriz(aDados)
		 *
	    &&	tamanho da largura da pagina : 718.1107
	    aadd(aHeaders,{'',0,''}) && é adicionado para elimitar um titulo superior ao nomes das colunas
	    aadd(aHeaders,{'ID'	  ,40 ,cPropriedadePadrao_Headers+"HAlign=haCenter"})
	    aadd(aHeaders,{'Nome' ,200,cPropriedadePadrao_Headers+"HAlign=haCenter"})
	    aadd(aHeaders,{'Admin',30 ,cPropriedadePadrao_Headers+"HAlign=haLeft"})
		 *
       FastReportModelo1(cTitulo,aHeaders,aMasterData,aFooter,"",.f.,"",.t.,1,"","Empresa Demonstração","Sistema de Demonstração")
		 *
		 (::cAlias)->(DbGoTop())