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
import Data.Int
import Database.Persist.Sql

getProfessorR :: Handler Html
getProfessorR = defaultLayout [whamlet|
        <h1>
            Seja Bem-Vindo Professor.
            
            Verificar sua classe: <a href=@{ClasseR}>aqui
            
        <form method=post action=@{DeslogarR}>
            <input type=submit value="Deslogar">
    |]