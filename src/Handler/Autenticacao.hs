{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE ViewPatterns               #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE DeriveDataTypeable         #-}

module Handler.Autenticacao where

import Yesod
import Yesod.Core
import Foundation
import Data.Text
import Database.Persist.Sql



formCadastro :: Form Usuarios
formCadastro = renderDivs $ Usuarios <$>
                 areq textField "E-mail" Nothing <*>
                 areq passwordField "Senha" Nothing   


formLogin :: Form (Text,Text)
formLogin = renderDivs $ (,) <$>
             areq textField "Usuário: " Nothing <*>
             areq passwordField "Senha: " Nothing 
  

--getCadastraR :: Handler Html
--getCadastraR = do
--    (widget, enctype) <- generateFormPost formCadastro
--    defaultLayout $ widgetForm CadastraR enctype widget "Cadastro" 
    
getCadastraR :: Handler Html
getCadastraR = do
    (widget, enctype) <- generateFormPost formCadastro
    defaultLayout $ [whamlet|
            <p>
                The widget generated contains only the contents
                of the form, not the form tag itself. So...
            <form method=post action=@{CadastraR}>
                ^{widget}
                <p>It also doesn't include the submit button.
                <button>Pau no seu cu
        |]


postCadastraR :: Handler Html
postCadastraR = do
                ((result, _), _) <- runFormPost formCadastro
                case result of
                    FormSuccess cadastro -> do
                       cadastroLR <- runDB $ insertBy cadastro
                       case cadastroLR of
                           Left _ -> redirect CadastraR
                           Right _ -> defaultLayout [whamlet|
                                          <h1> #{usuariosUser_name cadastro} Inserido com sucesso. 
                                      |]
                    _ -> redirect CadastraR


getLogarR :: Handler Html
getLogarR = do
    (widget, enctype) <- generateFormPost formLogin
    defaultLayout $ do
        setTitle "estud.club | A plataforma de aprendizado"
        addStylesheet $ StaticR estilos_css
        $(whamletFile "templates/login.hamlet")

   
postLogarR :: Handler Html
postLogarR = do
    ((result, _), _) <- runFormPost formLogin
    case result of
        FormSuccess (nome,senha) -> do
            mUsuario <- runDB $ getBy $ UniqueUsuario nome senha
            case mUsuario of
                Nothing -> do
                    setMessage "Erro! Usuário não existe"
                    redirect LogarR
                Just (Entity uid usuario ) -> do
                    -- setMessage "Autenticado"
                    alunoOuProfessor <- runDB $ selectFirst [ProfessoresUsuariosid ==. uid ] []
                    case alunoOuProfessor of
                        Nothing -> do
                            setSession "_USER" "ALUNO"
                            setSession "_ID" (pack $ show $ fromSqlKey uid)
                            setMessage "Aluno Autenticado"
                            redirect AlunoR 
                        Just (Entity pid professor ) -> do
                            setSession "_USER" "PROFESSOR"
                            setSession "_ID" (pack $ show $ fromSqlKey pid)
                            setMessage "Professor Autenticado"
                            redirect ProfessorR
        _ -> redirect LogarR


postDeslogarR :: Handler Html
postDeslogarR = do
    deleteSession "_USER"
    deleteSession "_ID"
    redirect LogarR