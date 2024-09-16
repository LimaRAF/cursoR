rm(list = ls())

# Mudando o diretório
setwd("C:/Users/renat/Documents/Ensino/disciplinas/pos/R/projetoX")
dir()
list.files()

# Chunk 1
pasta <- "data"
dir.create(pasta)
dir()

subpastas <- c("raw-data", "derived-data")
caminhos <- file.path(pasta, subpastas)
dir.create(caminhos[1])
dir.create(caminhos[2])
dir(pasta)

# Chunk 2
url <- "http://ecor.ib.usp.br/lib/exe/fetch.php?media=dados:caixeta.csv"
caminho <- file.path(caminhos[1], "caixeta.csv")
download.file(url, destfile = caminho)


# Chunk 3
dir.create("R")

eq_volume <- function(dap, 
                      b0 = -8.889, 
                      b1 = 1.881, 
                      b2 = 0.875, 
                      ff = 0.87) {
  
  volume <- ff * (exp( b0 + b1 * log(dap) + b2 * log(dap)))
  return(volume)
}  
dump("eq_volume", file="R/eq_volume.R")

# chunk 4
rm(list = "eq_volume")
ls()
source(file = "R/eq_volume.R")
ls()

# chunk 5
rm(list = ls())
arquivos <- list.files("R", full.names = TRUE)
sapply(arquivos, source)
eq_volume(10)

# chunk 6
dir.create("scripts")
url <- "http://ecor.ib.usp.br/lib/exe/fetch.php?media=dados:script_tutorial_organiza_diretorio.R"
caminho <- file.path("scripts", "analisa_dados.R")
download.file(url, destfile = caminho)

# chunk 7
dir.create("output")
dir()

# chunk 8
texto <- c("ProjetoX: comparando o volume arbóreo em caixetais do estado de São Paulo",
           "Autor: professores e monitores do curso de R do IB e ESALQ, USP",
           "Bugs: enviar problemas e sugestões para raflima@usp.br",
           "Organização: Este repositório contém na pasta 'data/' os dados do projeto, na pasta 'scripts/' os códigos para executar o projeto, na pasta 'R/' as funções internas usadas nos códigos e na pasta 'output/' os resultados dos códigos.",
           "Uso: para executar o projeto use o seguinte comando 'source(file.path('scripts', 'analisa_dados.R'))'",
           "Agradecimentos: PPG em Ecologia (IB) e em Recursos Florestais (ESALQ)")
writeLines(texto, "README.txt", sep = "\n\n")

# chunk 9
make <- c("## Executando o projeto X ##\n",
          "\n## Executando os códigos do projeto",
          "\n## Carregando os pacotes necessários",
          "### (Nenhum pacote sendo usado atualmente)\n",
          "\n## Carregando as funções internas",
          "source(file.path('R', 'eq_volume.R'))\n",
          "\n## Executando os códigos do projeto",
          "source(file.path('scripts', 'analisa_dados.R'))")
writeLines(make, "make.R", sep = "\n")

# chunk 10
source("make.R")

# outros chunks
file.create("simulação dos dados.R")
file.create("funcao1.R")
list.files()

file.copy(from= "simulação dos dados.R", 
          to= file.path("scripts", "simulação dos dados.R"))
file.rename(from= "funcao1.R", 
            to= file.path("R", "funcao1.R"))
list.files()

file.remove("simulação dos dados.R")
list.files()


arquivo1 <- list.files(path = 'scripts', pattern = 'ç', full.names = TRUE)
arquivo1.edit <- sub('simulação dos dados', 'simula_dados_volume_medio', arquivo1) 
file.rename(from= arquivo1, to= arquivo1.edit)


arquivo2 <- list.files(path = 'R', pattern = '1', full.names = TRUE)
arquivo2.edit <- sub('funcao1', 'simula_media', arquivo2) 
file.rename(from= arquivo2, to= arquivo2.edit)
