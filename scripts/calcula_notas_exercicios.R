##########################################
### Calculando as Notas dos Exercícios ###
##########################################

## Subindo o relatório de notas
pasta <- "notas_exercicios"
arquivos <- list.files(pasta)
ano <- 2024
arquivo_ano <- arquivos[grep(paste0(ano, "_"), arquivos)]
caminho <- file.path(pasta, arquivo_ano)
notas <- read.csv(caminho)

## Separando Calculando as notas de cada aluno
notas_ex_aula <- cbind.data.frame(notas[, c(1,2)], 
                                  notas[ , -grep("X110", colnames(notas))])
# notas_ex_aula <- cbind.data.frame(notas[, c(1,2)], 
#                                   notas[ , 3:max(grep("X104", colnames(notas)))])
notas_ex_finais <- notas[, c(1,2, grep("X110", colnames(notas)))]  
# notas_ex_finais[is.na(notas_ex_finais)] <- 35

## Calculando as notas de cada aluno
notasFinais <- get_notas(notas_ex_aula, notas_ex_finais)
intervalos <- findInterval(notasFinais$notaFinal, 
                                     vec = c(0,5,6.4999,7.999, 10) * 10)
lookup <- c("R", "C", "B", "A")
names(lookup) <- c("1", "2", "3","4")
notasFinais$conceito <- 
  stringr::str_replace_all(intervalos, lookup)
notasFinais[notasFinais$conceito %in% c("C", "B"),]

