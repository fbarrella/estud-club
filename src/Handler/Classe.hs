{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handler.Classe where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Data.Int
import Database.Persist.Postgresql

getClasseR :: Handler Html
getClasseR = do
    maybeUserIdText <- lookupSession "_ID"
    case maybeUserIdText of
        Nothing -> do
            defaultLayout [whamlet| Sem sessão|]
        Just userIdText -> do
            classe <- runDB $ get404 (toSqlKey (read $ unpack userIdText) :: ClasseId)
            defaultLayout [whamlet| 
                    Sua classe:
                <p>
            |]

getRelacaoR :: RelacaoId -> Handler Html
getRelacaoR rid = do
             relacao <- runDB $ get404 rid 
             alunos <- runDB $ get404 (relacaoAlunosid relacao)
             defaultLayout [whamlet|
                 #{alunosAluno_nm alunos}
             |]