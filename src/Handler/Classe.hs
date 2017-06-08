{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handler.Classe where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text

import Database.Persist.Postgresql

getExibeR :: Handler Html
getExibeR = undefined
    
getManageR :: Handler Html
getManageR = undefined

postManageR :: Handler Html
postManageR = undefined

getClasseR :: Handler Html
getClasseR = undefined

postClasseR :: Handler Html
postClasseR = undefined