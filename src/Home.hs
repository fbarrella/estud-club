{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Home where

import Foundation
import Yesod.Core

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    addStylesheet (StaticR teste_css)
    setTitle "Página teste"
    [whamlet|
        <h1>
            Título
        <p>
            Parágrafo
    |]