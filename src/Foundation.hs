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
        UniqueUSER_NAME user_name
        UniqueUSER_PASS user_pass
    
    Professores json
        prof_nm    Text
        usuariosid  UsuariosId
        
    Alunos json
        aluno_nm    Text
        aluno_nota    Double
        aluno_faltas    Int
        usuariosid    UsuariosId
    
    Escola json
        esc_nm    Text
    
    Disciplina  json
        di_nm   Text
    
    Classe json
        classe_nm   Text
        professoresid   ProfessoresId
        escolaid    EscolaId
        disciplinaid    DisciplinaId
        
    Relacao json
        classeid    ClasseId
        alunosid    AlunosId
        
    --Publi json
    --    publi_titulo Text
    --    publi_cont Text
    --    publi_data Day
    --    professoresid ProfessoresId
    --    classeid ClasseId
  
|]

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App

instance YesodPersist App where
   type YesodPersistBackend App = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool
