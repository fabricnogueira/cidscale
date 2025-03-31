class PrincipalController < ApplicationController
  def index
  end

  def calcular
    @olho_esquerdo = params[:olho_esquerdo]
    @olho_direito = params[:olho_direito]

    # Variáveis para o olho esquerdo
    @pl_esquerdo = params[:pl_esquerdo].present?
    @npl_esquerdo = params[:npl_esquerdo].present?
    @indeterminado_esquerdo = params[:indeterminado_esquerdo].present?
    @conta_dedos_esquerdo = params[:conta_dedos_esquerdo].present?
    @vultos_esquerdo = params[:vultos_esquerdo].present?

    # Variáveis para o olho direito
    @pl_direito = params[:pl_direito].present?
    @npl_direito = params[:npl_direito].present?
    @indeterminado_direito = params[:indeterminado_direito].present?
    @conta_dedos_direito = params[:conta_dedos_direito].present?
    @vultos_direito = params[:vultos_direito].present?
    
    # Verificar se há múltiplas seleções para o olho esquerdo
    left_eye_selections = [@pl_esquerdo, @npl_esquerdo, @indeterminado_esquerdo, @conta_dedos_esquerdo, @vultos_esquerdo].count(true)
    has_left_acuity = @olho_esquerdo.present?
    
    # Verificar se há múltiplas seleções para o olho direito
    right_eye_selections = [@pl_direito, @npl_direito, @indeterminado_direito, @conta_dedos_direito, @vultos_direito].count(true)
    has_right_acuity = @olho_direito.present?
    
    # Se houver múltiplas seleções ou seleção com valor numérico, retornar erro
    if (left_eye_selections > 1 || (left_eye_selections >= 1 && has_left_acuity)) || 
       (right_eye_selections > 1 || (right_eye_selections >= 1 && has_right_acuity))
      flash[:error] = "Por favor, selecione apenas uma opção ou informe a acuidade visual para cada olho."
      return redirect_to root_path
    end

    @categoria_esquerdo, @cid_esquerdo = categorizar_visao(@olho_esquerdo, @pl_esquerdo, @npl_esquerdo, @indeterminado_esquerdo, @conta_dedos_esquerdo, @vultos_esquerdo)
    @categoria_direito, @cid_direito = categorizar_visao(@olho_direito, @pl_direito, @npl_direito, @indeterminado_direito, @conta_dedos_direito, @vultos_direito)

    @descricao_cid = determinar_cid(@cid_esquerdo, @cid_direito)

    render :resultado
  end

  private

  def categorizar_visao(denominador, pl, npl, indeterminado, conta_dedos, vultos)
    return ["Categoria 5 - Cegueira (PL)", "H54.0"] if pl
    return ["Categoria 5 - Cegueira (NPL)", "H54.0"] if npl
    return ["Categoria 5 - Cegueira (Conta dedos)", "H54.0"] if conta_dedos
    return ["Categoria 5 - Cegueira (Vultos / movimento de mãos)", "H54.0"] if vultos
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
    else
      ["Categoria 4 - Cegueira", "H54.0"]
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
