SELECT 
    cf.Nome, 
    cf.cpf, 
    c.EmailLogin, 
    cf.DataNascimento,
    MAX(p.id) AS UltimoPedido, 
    MAX(p.DataEmissao) AS DataUltimoPedido  
FROM 
    Clientes c (NOLOCK)
INNER JOIN 
    ClientesPessoasFisicas cf (NOLOCK) 
		ON c.Id = cf.IdCliente
LEFT JOIN 
    pedidos p (NOLOCK) 
		ON c.id = p.IdCliente AND p.DataEmissao >= DATEADD(MONTH, -6, GETDATE())  -- Filtrando pedidos dos últimos 6 meses
WHERE 
    MONTH(cf.DataNascimento) = '01'
    AND p.id IS NOT NULL  -- Filtrar apenas registros com ID
    AND p.DataEmissao IS NOT NULL  -- Filtrar apenas registros com DataEmissao
GROUP BY 
    cf.Nome, cf.cpf, c.EmailLogin, cf.DataNascimento
ORDER BY 
    DataUltimoPedido desc;