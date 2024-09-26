WITH UltimosPedidos AS (
    SELECT
        cc.IdContrato, 
        cp.CNPJ, 
        cp.RazaoSocial, 
        p.IdPedido as 'Pedido', 
        ps.Descricao as 'Status do Pedido', 
        p.DataPedido, 
        u.Ativo,  
        u.Nome, 
        u.DDD_Telefone as 'DDD', 
        u.Num_Telefone as 'Telefone', 
        u.Email, 
        uc.IdCliente, 
        u.IdLogin,
        ROW_NUMBER() OVER (PARTITION BY u.IdLogin ORDER BY p.DataPedido DESC) AS RowNum
    FROM 
        ClientesPessoasJuridicas cp (nolock)
        INNER JOIN UsuarioCliente uc (nolock)
            ON uc.IdCliente = cp.IdCliente 
        INNER JOIN Usuarios u (nolock)
            ON u.IdLogin = uc.IdLogin 
        INNER JOIN ContratoCliente cc (nolock)
            ON cc.IdCliente = uc.IdCliente
        FULL OUTER JOIN Pedidos p (nolock) 
            ON p.IdLogin = uc.IdLogin 
            AND p.IdCliente = uc.IdCliente
        FULL OUTER JOIN PedidoStatus ps (nolock)
            ON ps.IdPedidoStatus = p.IdPedidoStatus   
    WHERE 
        cc.IdContrato IN (643, 1055, 3126, 405, 2585, 851, 3499) 
        AND (p.DataPedido >= '2020-01-01 00:00:00' OR p.DataPedido IS NULL)
)

-- Seleciona apenas os registros onde RowNum = 1 (último pedido por login)
SELECT 
    IdContrato, 
    CNPJ, 
    RazaoSocial, 
    Pedido, 
    [Status do Pedido], 
    DataPedido, 
    Ativo,  
    Nome, 
    DDD, 
    Telefone, 
    Email, 
    IdCliente, 
    IdLogin
FROM 
    UltimosPedidos
WHERE 
    RowNum = 1
ORDER BY 
    IdContrato;