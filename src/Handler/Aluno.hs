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

module Handler.Aluno where

import Yesod
import Yesod.Core
import Foundation
import Data.Text
import Data.Int
import Database.Persist.Sql


getAlunoR :: Handler Html
getAlunoR = defaultLayout [whamlet|
        <h1>
            Pagina inicial do aluno
        Deslogar
            <form method=post action=@{DeslogarR} >
                <input type=submit>
    |]



getAlunoTesteR :: Handler Html
getAlunoTesteR = do
    maybeUserIdText <- lookupSession "_ID"
    case maybeUserIdText of
        Nothing -> do
            defaultLayout [whamlet| Sem sessão|]
        Just userIdText -> do
            usuario <- runDB $ get404 (toSqlKey (read $ unpack userIdText) :: UsuariosId  )
            defaultLayout [whamlet| 
                id da sessao sem conversão:
                <p>
                    #{userIdText}
                dados do usuário vindo do banco de dados. Usando o ID extraido da sessão:
                <p>
                    #{show usuario}
                
            |]


getAlunoTeste2R :: Handler Html
getAlunoTeste2R = do
    maybeUserIdText <- lookupSession "_ID"
    case maybeUserIdText of
        Nothing -> do
            defaultLayout [whamlet| Sem sessão|]
        Just userIdText -> do
            classe <- runDB $ get404 (toSqlKey (read $ unpack userIdText) :: ClasseId  )
            defaultLayout [whamlet| 
                id da sessao sem conversão:
                <p>
                    #{userIdText}
                dados do usuário vindo do banco de dados. Usando o ID extraido da sessão:
                <pre>
                    #{show classe}
                
            |]