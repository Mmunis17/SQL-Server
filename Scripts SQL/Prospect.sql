SELECT
	p.IdProspect,
	p.DataInclusão as 'DataInclusao',
	FORMAT (p.DataAtualizacao, 'dd/MM/yyyy', 'en-gb') as 'DataAtualização',
	pe.CNPJ,
	pe.RazaoSocial,
	p.Nome,
	p.DddTelefone as 'DDD',
	p.NumeroTelefone,
	p.Email,
	ac.Nome as 'Ramo de Atividade',
	p.VolumeCompras,
	ps.Descricao,
	u.Nome as 'Responsavel'

FROM
	Prospects p (nolock)
	LEFT JOIN ProspectEnderecos pe (nolock)
		ON p.IdProspect = pe.IdProspect
	LEFT JOIN AtividadesClientesPessoasJuridicas ac (nolock)
		ON ac.IdAtividadeClientePessoaJuridica = p.IdAtividadesClientesPessoasJuridicas
	INNER JOIN ProspectSituacao ps (nolock)
		ON ps.IdProspectSituacao = p.IdProspectSituacao
	LEFT JOIN Usuarios u (nolock)
		ON u.IdLogin = p.IdLoginResponsavelAtual
WHERE pe.cnpj IN (
    SELECT pe.CNPJ 
    FROM
        Prospects p (nolock)
        LEFT JOIN ProspectEnderecos pe (nolock)
            ON p.IdProspect = pe.IdProspect
        LEFT JOIN AtividadesClientesPessoasJuridicas ac (nolock)
            ON ac.IdAtividadeClientePessoaJuridica = p.IdAtividadesClientesPessoasJuridicas
        INNER JOIN ProspectSituacao ps (nolock)
            ON ps.IdProspectSituacao = p.IdProspectSituacao
        LEFT JOIN Usuarios u (nolock)
            ON u.IdLogin = p.IdLoginResponsavelAtual
    GROUP BY pe.CNPJ
    HAVING COUNT(*) > 4 
)
ORDER BY pe.CNPJ;
