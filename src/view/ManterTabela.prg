#Include "Entidade.CH"

Function ManterTabela()

			MsgMeter( { | oMeter, oText, oDlg, lEnd | ;
             ManterTabela_Meter( oMeter, oText, oDlg, @lEnd ) },;
             "Manutenção de Tabelas", "Aguarde um momento..." )


Function ManterTabela_Meter(oMeter, oText, oDlg, lEnd)
			Local aTabelas:={},oTabela:=NIL,nTabela:=1
			*
			oUsuario := Usuario():New()
			oControleUsuario:= Tabela():New(oUsuario)
			oControleUsuario:AdicionarIndice("cNome","NOME")
			aadd(aTabelas,oControleUsuario)
			*
			oMeter:SetTotal(len(aTabelas))
			*
			For each oTabela in aTabelas
				oTabela:ManterTabela()
		      oTabela:ManterIndice()
				oMeter:Set(nTabela++)
			Next
			
			
			
