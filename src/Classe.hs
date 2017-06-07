{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Classe where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text

import Database.Persist.Postgresql

--getExibeR :: Handler Html
--getExibeR = redirect HomeR
    
--getManageR :: Handler Html
--getManageR = redirect HomeR

--postManageR :: Handler Html
--postManageR = redirect HomeR

--getClasseR :: Handler Html
--getClasseR = redirect HomeR

--postClasseR :: Handler Html
--postClasseR = redirect HomeR