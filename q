                                 Table "public.alunos"
    Column    |       Type        |                      Modifiers                      
--------------+-------------------+-----------------------------------------------------
 id           | bigint            | not null default nextval('alunos_id_seq'::regclass)
 aluno_nm     | character varying | not null
 aluno_nota   | double precision  | not null
 aluno_faltas | bigint            | not null
 usuariosid   | bigint            | not null
Indexes:
    "alunos_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "alunos_usuariosid_fkey" FOREIGN KEY (usuariosid) REFERENCES usuarios(id)
Referenced by:
    TABLE "relacao" CONSTRAINT "relacao_alunosid_fkey" FOREIGN KEY (alunosid) REFERENCES alunos(id)

