#Include "Entidade.CH"
 
CLASS Usuario FROM Entidade

   DATA cNome AS CHARACTER INIT SPACE(50)
   DATA cSenha AS CHARACTER INIT SPACE(50)
   DATA lAdministrador AS LOGICAL INIT .F.
   DATA cOBS AS CHARACTER INIT Memo()
   
	METHOD New() CONSTRUCTOR

ENDCLASS

METHOD New() CLASS Usuario
		 ::Super():New()
return Self


