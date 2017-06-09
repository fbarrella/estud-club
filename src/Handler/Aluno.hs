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
getAlunoR = do
    maybeUserIdText <- lookupSession "_ID"
    case maybeUserIdText of
        Nothing -> do
            defaultLayout [whamlet| Sem sessão |]
        Just userIdText -> do
            alunos <- runDB $ get404 (toSqlKey (read $ unpack userIdText) :: AlunosId)
            defaultLayout [whamlet|
               <h1>
                   Seja bem vindo, <span .nome>#{alunosAluno_nm alunos}</span>!
            
               Sua nota é #{alunosAluno_nota alunos} e você tem #{alunosAluno_faltas alunos} faltas.

               <form method=post action=@{DeslogarR}>
                   <input type=submit value="Deslogar">
        |]