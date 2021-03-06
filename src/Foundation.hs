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

module Foundation where

import Yesod
import Data.Text
import Database.Persist
import Data.Time.Calendar
import Yesod.Core
import Yesod.Static
import Database.Persist.Postgresql
    ( ConnectionPool, SqlBackend, runSqlPool, runMigration )

data App = App
    {
        getStatic      :: Static,
        connPool       :: ConnectionPool
    }

share [mkPersist sqlSettings, mkMigrate "migrateAll"][persistLowerCase|
    Usuarios json
        user_name     Text
        user_pass     Text
        UniqueUsuario user_name user_pass
        deriving Show
    
    Professores json
        prof_nm    Text
        usuariosid  UsuariosId
        deriving Show
        
    Alunos json
        aluno_nm    Text
        aluno_nota    Double
        aluno_faltas    Int
        usuariosid    UsuariosId
        deriving Show
    
    Escola json
        esc_nm    Text
    
    Disciplina  json
        di_nm   Text
    
    Classe json
        classe_nm   Text
        professoresid   ProfessoresId
        escolaid    EscolaId
        disciplinaid    DisciplinaId
        deriving Show
        
    Relacao json
        classeid    ClasseId
        alunosid    AlunosId
        deriving Show
  
|]

staticFiles "static"

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App where
    authRoute _ = Just LogarR
    
    isAuthorized LogarR _ = return Authorized
    
    isAuthorized ProfessorR _ = ehProfessor
    
    isAuthorized AlunoR _ = ehAluno

    isAuthorized _ _ = return Authorized
    

instance YesodPersist App where
   type YesodPersistBackend App = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool
      
      
ehProfessor = do
    mu <- lookupSession ("_USER" :: Text)
    return $ case mu of
        Nothing -> AuthenticationRequired
        Just "PROFESSOR" -> Authorized
        Just _ -> Unauthorized "<h1>Acesso não permitido!</h1>"

ehAluno = do
    mu <- lookupSession ("_USER" :: Text)
    return $ case mu of
        Nothing -> AuthenticationRequired
        Just "ALUNO" -> Authorized


type Form a = Html -> MForm Handler (FormResult a, Widget)

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

widgetForm :: Route App -> Enctype -> Widget -> Text -> Widget
widgetForm x enctype widget y = $(whamletFile "templates/form.hamlet")