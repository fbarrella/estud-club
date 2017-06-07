{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Home where

import Foundation
import Yesod.Core

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Página teste"
    addStylesheet $ StaticR estilos_css
    [whamlet|
        <h1>
            Título
        <p>
            Parágrafo
    |]