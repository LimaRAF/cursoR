#'
#' @title Notas Finais
#'
#' @description Calcula a média ponderada final de cada aluno, baseado
#'   nas notas dos exercícios de aula e dos exercícios da lista final
#'
#' @param aulas um 'data frame' com os nomes e email dos alunos e os 
#' resultados aos exercícios das aulas
#' @param finais um 'data frame' com os nomes e email dos alunos e os 
#' resultados aos exercícios da lista final
#' @param peso_aulas numerico. O peso dado aos exercícios das aulas.
#'   Padrão é 0.8
#' @param peso_finais numerico. O peso dado aos exercícios finais.
#'   Padrão é 0.2
#' @param rm.min A menor nota dos exercícios das aulas deve ser
#'   removida antes do cálculo da nota final? Padrão é 'sim' (i.e. TRUE)
#' @param rm.all.na Os exercícios (colunas) sem nota para nenhum dos
#'   alunos devem ser removidos? Padrão é 'sim' (i.e. TRUE)
#'
#' @return um data frame com os nomes dos alunos e a média final na
#'   coluna `notaFinal`
#'
#' @author Renato A. F. de Lima
#'
#'
#' @keywords internal
#'
get_notas <- function(aulas = NULL, 
                      finais = NULL, 
                      peso_aulas = 0.8,
                      peso_finais = 0.2,
                      rm.min = TRUE,
                      rm.all.na = TRUE) {
  
  aulas = notas_ex_aula
  finais = notas_ex_finais
  peso_aulas = 0.8
  peso_finais = 0.2
  rm.min = TRUE
  rm.all.na = TRUE
  
  if (rm.all.na) {
    aulas <- aulas[, apply(aulas, 2, function(x) any(!is.na(x)))]
    finais <- finais[, apply(finais, 2, function(x) any(!is.na(x)))]
  }
  
  aulas[is.na(aulas)] <- 0
  finais[is.na(finais)] <- 0
  
  if (rm.min) {
    get_nota <- function(x) mean(x[-which.min(x)])
    media_topicos <- apply(aulas[,-(1:2)], 1, get_nota)
  } else {
    media_topicos <- apply(aulas[,-(1:2)], 1, mean)
  }
  
  media_lista <- apply(finais[,-(1:2)], 1, mean)
  media_lista[is.nan(media_lista)] <- 0
  notaFinal <- peso_aulas * media_topicos + 
    peso_finais * media_lista
  
  notas <- finais[,(1:2)]
  notas$notaFinal <- notaFinal
  
  return(notas)
}
