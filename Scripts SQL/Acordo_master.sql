SELECT
    cc.IdContrato, 
    ct.Descricao AS 'Tipo', 
    cp.CNPJ, 
    cp.RazaoSocial,
    
    -- Subconsulta para trazer o Nome e o Email em colunas separadas
    (SELECT TOP 1 u.Nome 
     FROM Usuarios u 
     WHERE u.IdClienteResponsavel = cp1.IdCliente AND u.IdPerfilUsuario = 3 and u.Ativo = 'S'
     ORDER BY u.IdLogin) AS 'Nome',
     
    (SELECT TOP 1 u.Email 
     FROM Usuarios u 
     WHERE u.IdClienteResponsavel = cp1.IdCliente AND u.IdPerfilUsuario = 3 and u.Ativo = 'S'
     ORDER BY u.IdLogin) AS 'Email',

	 (SELECT TOP 1 u.DDD_Telefone 
     FROM Usuarios u 
     WHERE u.IdClienteResponsavel = cp1.IdCliente AND u.IdPerfilUsuario = 3 and u.Ativo = 'S'
     ORDER BY u.IdLogin) AS 'DDD',

	 (SELECT TOP 1 u.Num_Telefone 
     FROM Usuarios u 
     WHERE u.IdClienteResponsavel = cp1.IdCliente AND u.IdPerfilUsuario = 3
     ORDER BY u.IdLogin) AS 'Telefone',

    CASE 
        WHEN cc.Ativo = 'S' THEN 'Sim' 
        ELSE 'Não' 
    END AS 'CNPJ Ativo no Contrato',
    
    CASE 
        WHEN cp1.CNPJ = cp.CNPJ THEN 'Sim' 
        ELSE 'Não' 
    END AS 'CNPJ é Matriz?'
    
FROM 
    ClientesPessoasJuridicas cp WITH (NOLOCK)
    INNER JOIN ContratoCliente cc WITH (NOLOCK)
        ON cc.IdCliente = cp.IdCliente and cc.Ativo = 'S'
    INNER JOIN Contratos c WITH (NOLOCK)
        ON c.IdContrato = cc.IdContrato
    INNER JOIN ContratoTipo ct WITH (NOLOCK)
        ON ct.IdContratoTipo = c.IdContratoTipo
    INNER JOIN ClientesPessoasJuridicas cp1 WITH (NOLOCK)
        ON cp1.IdCliente = c.IdClienteMatriz
WHERE 
    1=1
    --AND d.IdContrato = 954
	AND ct.Descricao = 'Acordo SPOT'
ORDER BY cc.IdContrato;