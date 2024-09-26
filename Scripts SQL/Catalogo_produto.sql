select DISTINCT
	c.IdCatalogo,
	c.Descricao as 'Nome Catalogo',
    cp.IdProduto, 
    pr.CodigoERP, 
    cp.PrecoVenda, 
    cp.Ativo as 'Produto Ativo', 
    pr.PrecoReposicao, 
    ((cp.PrecoVenda - pr.PrecoReposicao) / cp.PrecoVenda) * 100 as 'Markon'
from
    Catalogo c with (nolock)
	inner join CatalogoProdutos cp with (nolock)
		on cp.IdCatalogo = c.IdCatalogo
	inner join Produtos pr
		on pr.IdProduto = cp.IdProduto
where 
    c.IdCatalogo in (2463, 2738, 2740, 2741, 2742, 2743, 2744, 2745, 2746, 2879)
order by c.IdCatalogo;