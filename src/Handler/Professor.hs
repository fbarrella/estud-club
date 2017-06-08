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

module Handler.Professor where

import Yesod
import Yesod.Core
import Foundation
import Data.Text



getProfessorR :: Handler Html
getProfessorR = defaultLayout [whamlet|
        <h1>
            Professor
        Deslogar:
        <form method=post action=@{DeslogarR}>
            <input type=submit>
    |]


{-

formLogin :: Form (Text,Text)
formLogin = renderDivs $ (,) <$>
             areq textField "login" Nothing <*>
             areq textField "senha" Nothing 
  

getLogarR :: Handler Html
getLogarR = do
    (widget, enctype) <- generateFormPost formLogin
    defaultLayout $ widgetForm LogarR enctype widget "Login" 

   
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
                    setMessage "Autenticado"
                    redirect LogarR
        _ -> redirect LogarR



getDeslogarR :: Handler Html
getDeslogarR = undefined

postDeslogarR :: Handler Html
postDeslogarR = undefined
-}