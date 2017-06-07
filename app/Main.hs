{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Main where
import Yesod
import Yesod.Static
import Foundation
import Application
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Database.Persist.Postgresql

connStr = "dbname=d1ojupkeigepp host=ec2-107-20-226-93.compute-1.amazonaws.com user=cmykskyjzzlpue password=6fb9608b8839e280961e1a3ccbc3fef4a93298f879c39756078e74f9a095146c port=5432"

main :: IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool 
       t@(Static settings) <- static "static"
       warp 8080 (App t pool)