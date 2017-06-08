{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application where

import Foundation
import Yesod.Core
import Yesod

import Home
import Classe
import Usuario


import Handler.Autenticacao
import Handler.Professor
import Handler.Aluno

mkYesodDispatch "App" resourcesApp