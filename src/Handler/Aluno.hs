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

getAlunoR :: Handler Html
getAlunoR = defaultLayout [whamlet|
        <h1>
            Pagina inicial do aluno
        Deslogar
            <form method=post action=@{DeslogarR} >
                <input type=submit>
    |]
