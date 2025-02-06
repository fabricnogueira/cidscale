class PrincipalController < ApplicationController
  def index
    # Exibe o formulário para entrada dos valores
  end

  def calcular
    @olho_esquerdo = params[:olho_esquerdo]
    @olho_direito = params[:olho_direito]

    @categoria_esquerdo, @cid_esquerdo = categorizar_visao(@olho_esquerdo)
    @categoria_direito, @cid_direito = categorizar_visao(@olho_direito)

    @descricao_cid = determinar_cid(@cid_esquerdo, @cid_direito)

    render :resultado
  end

  private

  def categorizar_visao(denominador)
    numerador = 20.0

    return ["Valor inválido", "N/A"] if denominador.blank? || denominador.to_f == 0

    fracao = numerador / denominador.to_f

    case
    when fracao >= (20.0 / 40)
      ["Categoria 0 - Sem deficiência visual", "N/A"]
    when fracao >= (20.0 / 70)
      ["Categoria 1 - Deficiência visual leve", "H54.2"]
    when fracao >= (20.0 / 200)
      ["Categoria 2 - Deficiência visual moderada", "H54.2"]
    when fracao >= (20.0 / 400)
      ["Categoria 3 - Deficiência visual grave", "H54.1"]
    when fracao >= (20.0 / 1200)
      ["Categoria 4 - Cegueira", "H54.0"]
    when denominador.to_f == 60 # Contagem de dedos a 1 metro
      ["Categoria 4 - Cegueira", "H54.0"]
    when denominador.to_s.downcase == "pl" # Percepção de luz
      ["Categoria 5 - Cegueira (apenas percepção de luz)", "H54.0"]
    when denominador.to_s.downcase == "npl" # Nenhuma percepção de luz
      ["Categoria 5 - Cegueira (sem percepção de luz)", "H54.0"]
    else
      ["Categoria 9 - Indeterminada ou não especificada", "H54.7"]
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
