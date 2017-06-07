{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Classe where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text

import Database.Persist.Postgresql

getExibeR :: Handler Html
getExibeR = defaultLayout $ do [whamlet| |]
    
getManageR :: Handler Html
getManageR = defaultLayout $ do [whamlet| |]

postManageR :: Handler Html
postManageR = defaultLayout $ do [whamlet| |]

getClasseR :: Handler Html
getClasseR = defaultLayout $ do [whamlet| |]

postClasseR :: Handler Html
postClasseR = defaultLayout $ do [whamlet| |]