/* Obs.
1- Promoção nesse momento para clientes que fizeram a primeira compra no app (Sim, na coluna 'PedidoApp')
2- Promoção valida a partir de 07/02/2022
3- Nesse primeiro momento, o cliente está ganhando 50 reais (10000 pontos) de gimplus
*/

DROP TABLE IF EXISTS #tempPedidos;
DROP TABLE IF EXISTS #tempApp;
DROP TABLE IF EXISTS #tempPrimeiroPedidoApp;
DROP TABLE IF EXISTS #tempProdutos;

select 
	a.id as IdPedido, 
	FORMAT (a.DataEmissao, 'dd/MM/yyyy', 'en-gb') as 'Data de Emissão',
	FORMAT (a.DataEmissao, 'MM/yyyy', 'en-gb') as 'MesAno', a.DataEmissao, 
	a.ValorTotal, 
	c.Descricao, 
	coalesce(d.CNPJ, e.CPF) as CPFCNPJ,
	coalesce(d.RazaoSocial,e.nome) as Nome, 
	f.EmailLogin as Email, 
	coalesce(d.TelefoneComercialDDD, e.TelefoneCelularDDD) as DDD, 
	coalesce(d.TelefoneComercialNumero,e.TelefoneCelularNumero) as Telefone, 
	a.IdCliente
into #tempPedidos
from pedidos a (nolock)
	inner join PedidosApp b (nolock)
		on a.Id = b.idPedido
	inner join PedidosStatus c (nolock)
		on a.IdStatus = c.Id
	left join ClientesPessoasJuridicas d (nolock)
		on a.IdCliente = d.IdCliente
	left join ClientesPessoasFisicas e (nolock)
		on a.IdCliente = e.IdCliente
	inner join Clientes f (nolock)
		on a.IdCliente = f.Id
		order by 1 asc


	select min(a.Id) as PrimeiroPedido, b.IdCliente
		into #tempApp
	from Pedidos a (nolock)
		inner join #tempPedidos b
			on a.IdCliente = b.IdCliente
		left join PedidosApp c (nolock)
			on a.Id = c.idPedido
			group by b.IdCliente

select c.IdCliente, MIN(a.idPedido)  as PrimeiroPedidoApp
	into #tempPrimeiroPedidoApp
from PedidosApp a (nolock)
	inner join Pedidos b (nolock)
		on a.idPedido = b.Id
	inner join #tempPedidos c
		on b.IdCliente = c.IdCliente
		group by c.IdCliente


select c.IdPedido, SUM(b.ValorTotal) as ValorTotalProdutos 
	into #tempProdutos
from pedidos a (nolock)
	inner join PedidosItens b (nolock)
		on a.id = b.IdPedido
	inner join #tempPedidos c
		on a.Id = c.IdPedido
		GROUP BY c.IdPedido



	select 
	a.IdPedido,
	a.[Data de Emissão],
	a.[MesAno],
	a.Descricao,
	d.ValorTotalProdutos,
	ValorTotal,
	b.PrimeiroPedido as PrimeiroPedidoRealizado, 
	c.PrimeiroPedidoApp,
	CPFCNPJ,
	Nome,
	Email,
	DDD,
	Telefone,
	a.IdCliente
	from #tempPedidos a
		inner join #tempApp b
			on a.IdCliente = b.IdCliente
		inner join #tempPrimeiroPedidoApp c
			on a.IdCliente = c.IdCliente
		inner join #tempProdutos d
			on a.IdPedido = d.IdPedido

Order By a.DataEmissao
