class PrincipalController < ApplicationController
  def index
    # Exibe o formulário para entrada dos valores
  end

  def calcular
    @olho_esquerdo = params[:olho_esquerdo]
    @olho_direito = params[:olho_direito]

    @categoria_esquerdo = categorizar_visao(@olho_esquerdo)
    @categoria_direito = categorizar_visao(@olho_direito)

    render :resultado
  end

  private
  def categorizar_visao(denominador)
    numerador = 20.0
  
    if denominador.to_f == 0
      return "Valor inválido"
    end
  
    fracao = numerador / denominador.to_f
  
    # Classificação com base na tabela 20/1200
    if fracao >= (20.0 / 40)
      "Categoria 0 - Sem deficiência visual"
    elsif fracao >= (20.0 / 70)
      "Categoria 1 - Deficiência visual leve"
    elsif fracao >= (20.0 / 200)
      "Categoria 2 - Deficiência visual moderada"
    elsif fracao >= (20.0 / 400)
      "Categoria 3 - Deficiência visual grave"
    elsif fracao >= (20.0 / 1200)
      "Categoria 4 - Cegueira"
    else
      "Categoria 5 - Cegueira"
    end
  end
end
