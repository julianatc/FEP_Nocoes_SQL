/*
CURSO DE FORMAÇĀO PYTHON EXPERT 

NOÇŌES DE SQL - BUSINESS CASE: 

Imagine que você é um analista de dados de uma grande rede de lojas e tem acesso direto ao banco de dados onde estão 
persistidas todas as informações de vendas.
Você acaba de receber um e-mail do seu gestor com os seguintes questionamentos:

Qual foi a quantidade total de vendas realizadas ? Qual foi o valor total de vendas?
Qual foi o valor total do lucro?
Qual foi a loja que mais obteve lucro?
Quem foi o vendedor com o melhor desempenho (maior valor de venda)?

Crie um relatório com a quantidade de vendas e valor total de vendas por loja e por vendedor, 
ordenado pelos respectivos campos.
Utilize os seus conhecimentos na linguagem SQL para realizar as análises no Banco de Dados e responder às perguntas!
*/

-- SOLUÇĀO; 

WITH

-- view tabela vendas completa
VENDA_AGRUP AS (SELECT COUNT(tab.quantidade) qtd_total_vendas,
                       ROUND(SUM(tab.valor_unitario * tab.quantidade),2) vlr_total_vendas,
                       ROUND(SUM(tab.valor_unitario * quantidade) - SUM(tab.preco_custo*quantidade),2) vlr_total_lucro
                    FROM VENDA tab
                ),

-- view relatorio
REL AS (SELECT l.codigo_loja, 
               l.nome_loja,
               vb.matricula_vendedor,
               vb.nome_vendedor,
               COUNT(va.quantidade) qtd_total_vendas,
               ROUND(SUM(va.valor_unitario * va.quantidade),2) AS valor_total_vendas,
               ROUND(SUM((va.valor_unitario * va.quantidade) - (va.preco_custo * quantidade)),2) valor_total_lucro
           FROM VENDA va 
           JOIN VENDEDOR vb ON va.matricula_vendedor = vb.matricula_vendedor
           JOIN LOJA l ON l.codigo_loja = va.codigo_loja
         GROUP BY l.codigo_loja, 
                  l.nome_loja, 
                  vb.matricula_vendedor,
                  vb.nome_vendedor),

LOJA_LUCRO AS (SELECT rel.nome_loja, 
                      ROUND(SUM (REL.valor_total_lucro),2) LUCRO
                    FROM REL
                    GROUP BY rel.nome_loja),

VENDEDOR_PERFORMANCE AS (SELECT rel.nome_vendedor, 
                                SUM (rel.valor_total_vendas) tot_vendas
                            FROM REL
                            GROUP BY rel.nome_vendedor)

-- EXECUTAR TODA A CLAUSULA WITH COM CADA QUERY RESULT (LINHAS 67, 73, 79 e 85 A 92) SEPARADAMENTE, ASSIM COMENTANDO AS DEMAIS LINHAS 

-- Qual foi a quantidade total de vendas realizadas ?  R: 3000 vendas
-- Qual foi o valor total de vendas?  R: R$ 6704846,61
-- Qual foi o valor total do lucro?  R: R$ 2762533,81
 
-- SELECT va.qtd_total_vendas, va.vlr_total_vendas, va.vlr_total_lucro FROM VENDA_AGRUP va;

-----------

-- Qual foi a loja que mais obteve lucro?  R: Matriz, lucro de R$ 731201,97
 
 -- SELECT * from LOJA_LUCRO l ORDER BY l.lucro DESC ;

 ---------

-- Quem foi o vendedor com o melhor desempenho (maior valor de venda)?  R: Jose Maria , vendeu total de 654050,81
  
  --  SELECT * from VENDEDOR_PERFORMANCE p ORDER BY p.tot_vendas DESC ;

-----------

-- /* 

-- Relatório 
SELECT rel.nome_loja, 
       rel.nome_vendedor, 
       rel.qtd_total_vendas, 
       rel.valor_total_vendas 
    FROM REL 
  ORDER BY rel.nome_loja, 
           rel.nome_vendedor;

-- */

