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

  def categorizar_visao(valor)
    # Converte o valor em uma fração numérica
    partes = valor.split('/')
    if partes.length == 2
      numerador = partes[0].to_f
      denominador = partes[1].to_f

      if denominador == 0
        return "Valor inválido"
      end

      fracao = numerador / denominador

      if fracao >= (6.0 / 60)
        "Categoria 1 - Deficiência visual moderada"
      elsif fracao >= (3.0 / 60)
        "Categoria 2 - Deficiência visual severa"
      elsif fracao >= (1.0 / 60)
        "Categoria 3 - Cegueira"
      else
        "Categoria 4 - Cegueira"
      end
    else
      "Valor inválido"
    end
  end
end
