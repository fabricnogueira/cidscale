class PrincipalController < ApplicationController
  def index
  end

  def calcular
    @olho_esquerdo = params[:olho_esquerdo]
    @olho_direito = params[:olho_direito]

    @pl_esquerdo = params[:pl_esquerdo].present?
    @npl_esquerdo = params[:npl_esquerdo].present?
    @indeterminado_esquerdo = params[:indeterminado_esquerdo].present?

    @pl_direito = params[:pl_direito].present?
    @npl_direito = params[:npl_direito].present?
    @indeterminado_direito = params[:indeterminado_direito].present?

    @categoria_esquerdo, @cid_esquerdo = categorizar_visao(@olho_esquerdo, @pl_esquerdo, @npl_esquerdo, @indeterminado_esquerdo)
    @categoria_direito, @cid_direito = categorizar_visao(@olho_direito, @pl_direito, @npl_direito, @indeterminado_direito)

    @descricao_cid = determinar_cid(@cid_esquerdo, @cid_direito)

    render :resultado
  end

  private

  def categorizar_visao(denominador, pl, npl, indeterminado)
    return ["Categoria 5 - Cegueira (PL)", "H54.0"] if pl
    return ["Categoria 5 - Cegueira (NPL)", "H54.0"] if npl
    return ["Categoria 9 - Indeterminado", "H54.7"] if indeterminado

    numerador = 20.0
    return ["Valor inválido", "N/A"] if denominador.blank? || denominador.to_f == 0

    fracao = numerador / denominador.to_f

    if fracao >= (20.0 / 40)
      ["Categoria 0 - Sem deficiência visual", "N/A"]
    elsif fracao >= (20.0 / 70)
      ["Categoria 1 - Deficiência visual leve", "H54.2"]
    elsif fracao >= (20.0 / 200)
      ["Categoria 2 - Deficiência visual moderada", "H54.2"]
    elsif fracao >= (20.0 / 400)
      ["Categoria 3 - Deficiência visual grave", "H54.1"]
    elsif denominador.to_f > 400
      ["Categoria 4 - Cegueira", "H54.0"]
    else
      ["Categoria 5 - Cegueira", "H54.0"]
    end
  end

  def determinar_cid(cid_esquerdo, cid_direito)
    if cid_esquerdo == "H54.0" && cid_direito == "H54.0"
      "H54.0 - Cegueira bilateral"
    elsif cid_esquerdo == "H54.0" || cid_direito == "H54.0"
      "H54.4 - Cegueira em um olho"
    elsif cid_esquerdo == "H54.2" && cid_direito == "H54.2"
      "H54.2 - Visão subnormal bilateral"
    elsif cid_esquerdo == "H54.1" || cid_direito == "H54.1"
      "H54.1 - Cegueira em um olho e visão subnormal no outro"
    else
      "H54.7 - Perda não especificada da visão"
    end
  end
end
