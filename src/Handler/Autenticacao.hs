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
                 areq textField "Your user: " Nothing <*>
                 areq passwordField "Your pass: " Nothing


formLogin :: Form (Text,Text)
formLogin = renderDivs $ (,) <$>
             areq textField "User: " Nothing <*>
             areq passwordField "Pass: " Nothing


   
getCadastraR :: Handler Html
getCadastraR = do
    (widget, enctype) <- generateFormPost formCadastro
    defaultLayout $ do
        setTitle "estud.club | A plataforma do saber"
        addStylesheet $ StaticR estilos_css
        $(whamletFile "templates/cadastro.hamlet") 


postCadastraR :: Handler Html
postCadastraR = do
                ((result, _), _) <- runFormPost formCadastro
                case result of
                    FormSuccess cadastro -> do
                       cadastroLR <- runDB $ insertBy cadastro
                       case cadastroLR of
                           Left _ -> redirect CadastraR
                           Right _ -> defaultLayout [whamlet|
                                          <h1> <span .nome>#{usuariosUser_name cadastro}</span> inserido com sucesso.
                                          
                                          <form method=post action=@{DeslogarR}>
                                              <input type=submit value="Voltar">
                                      |]
                    _ -> redirect CadastraR


getLogarR :: Handler Html
getLogarR = do
    (widget, enctype) <- generateFormPost formLogin
    defaultLayout $ do
        setTitle "estud.club | A plataforma do saber"
        addStylesheet $ StaticR estilos_css
        $(whamletFile "templates/login.hamlet")
        toWidget [lucius|
            input { background-color: white; border:1px solid black; border-radius: 3px; padding:0; margin:0 auto; height: 30px; text-align: right;}
        |]
        
        
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
                    --setMessage "Autenticado"
                    alunoOuProfessor <- runDB $ selectFirst [ProfessoresUsuariosid ==. uid ] []
                    case alunoOuProfessor of
                        Nothing -> do
                            setSession "_USER" "ALUNO"
                            setSession "_ID" (pack $ show $ fromSqlKey uid)
                            redirect AlunoR 
                        Just (Entity pid professor ) -> do
                            setSession "_USER" "PROFESSOR"
                            setSession "_ID" (pack $ show $ fromSqlKey pid)
                            redirect ProfessorR
        _ -> redirect LogarR


postDeslogarR :: Handler Html
postDeslogarR = do
    deleteSession "_USER"
    deleteSession "_ID"
    redirect LogarR